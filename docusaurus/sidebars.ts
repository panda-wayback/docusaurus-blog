import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';
import {buildSidebarsFromDocFolders} from './docs-nav-autogen';

// 顶层 docs 子目录各对应一个侧栏 + 顶栏「标签」；新增文件夹即自动出现（无需改配置）
const sidebars: SidebarsConfig = {
  ...buildSidebarsFromDocFolders(),
};

export default sidebars;
