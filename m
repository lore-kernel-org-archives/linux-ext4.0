From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 00/14] use atomic_dec_not_zero()
Date: Mon, 30 Jan 2017 19:39:20 +0100
Message-ID: <20170130183920.12476-1-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-s390@vger.kernel.org, linux-pm@vger.kernel.org,
	kgdb-bugreport@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Akinobu Mita <akinobu.mita@gmail.com>, linux-xfs@vger.kernel.org,
	Fabian Frederick <fabf@skynet.be>,
	openipmi-developer@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-media@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <openipmi-developer-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/openipmi-developer>,
	<mailto:openipmi-developer-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=openipmi-developer>
List-Post: <mailto:openipmi-developer@lists.sourceforge.net>
List-Help: <mailto:openipmi-developer-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/openipmi-developer>,
	<mailto:openipmi-developer-request@lists.sourceforge.net?subject=subscribe>
Errors-To: openipmi-developer-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

complementary definition to atomic_inc_not_zero() featured in
lib/fault-inject.c. This small patchset moves it to
include/linux/atomic.h using it instead of
atomic_add_unless(value, -1, 0)

s390 patches were not compile-tested.

Fabian Frederick (14):
  locking/atomic: import atomic_dec_not_zero()
  drm/exynos: use atomic_dec_not_zero()
  drm/omap: use atomic_dec_not_zero()
  m5mols: use atomic_dec_not_zero()
  omap3isp: use atomic_dec_not_zero()
  s390/qeth: use atomic_dec_not_zero()
  PM / RUNTIME: use atomic_dec_not_zero()
  ipmi: use atomic_dec_not_zero()
  kdb: use atomic_dec_not_zero()
  PM / Hibernate: use atomic_dec_not_zero()
  PM: use atomic_dec_not_zero()
  s390/topology: use atomic_dec_not_zero()
  ext4: use atomic_dec_not_zero()
  xfs: use atomic_dec_not_zero()

 arch/s390/kernel/topology.c               | 2 +-
 drivers/base/power/runtime.c              | 4 ++--
 drivers/char/ipmi/ipmi_msghandler.c       | 2 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c  | 2 +-
 drivers/gpu/drm/omapdrm/omap_dmm_tiler.c  | 2 +-
 drivers/media/i2c/m5mols/m5mols_core.c    | 2 +-
 drivers/media/platform/omap3isp/ispstat.c | 2 +-
 drivers/s390/net/qeth_core_main.c         | 2 +-
 fs/ext4/ext4.h                            | 2 +-
 fs/xfs/xfs_buf.c                          | 2 +-
 include/linux/atomic.h                    | 2 ++
 kernel/debug/kdb/kdb_main.c               | 2 +-
 kernel/power/hibernate.c                  | 4 ++--
 kernel/power/user.c                       | 2 +-
 lib/fault-inject.c                        | 2 --
 15 files changed, 17 insertions(+), 17 deletions(-)

-- 
2.9.3


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
