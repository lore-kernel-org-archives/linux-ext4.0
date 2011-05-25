From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/4] printk: cleanups of direct includes
Date: Wed, 25 May 2011 10:02:37 -0700
Message-ID: <cover.1306342673.git.joe@perches.com>
References: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
	linux-ia64@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.infradead.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, kvm-ia64@vger.kernel.org,
	kvm@vger.kernel.org, linux-ext4@vger.kernel.org, oprofile-list@lists.sf.net
Return-path: <devel-bounces@linuxdriverproject.org>
In-Reply-To: <BANLkTimo30L7feKr9_Ec=fMoe1erw8Rnag@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Sender: devel-bounces@linuxdriverproject.org
Errors-To: devel-bounces@linuxdriverproject.org
List-Id: linux-ext4.vger.kernel.org

printk.h is a subfile of kernel.h, do not allow it to
be included directly.

Joe Perches (4):
  treewide: Remove direct includes of printk.h
  staging: Remove direct includes of printk.h
  printk: Don't allow direct inclusion
  treewide: Remove asmlinkage from printk

 arch/arm/kernel/early_printk.c                |    2 +-
 arch/ia64/kvm/vmm.c                           |    2 +-
 arch/x86/kernel/early_printk.c                |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |    1 -
 drivers/staging/brcm80211/util/bcmutils.c     |    1 -
 drivers/staging/usbip/usbip_common.h          |    2 +-
 fs/ext4/inode.c                               |    1 -
 include/linux/oprofile.h                      |    2 +-
 include/linux/printk.h                        |   10 +++++++---
 kernel/printk.c                               |    6 +++---
 kernel/sysctl.c                               |    3 +--
 11 files changed, 16 insertions(+), 16 deletions(-)

-- 
1.7.4.rc3
