From: Martin Michlmayr <tbm@cyrius.com>
Subject: ext4dev build failure on mips: "empty_zero_page" undefined
Date: Mon, 12 May 2008 15:06:04 +0200
Message-ID: <20080512130604.GA15008@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: linux-mips@linux-mips.org
Return-path: <linux-mips-bounce@linux-mips.org>
Content-Disposition: inline
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-Id: linux-ext4.vger.kernel.org

I get the following build failure on MIPS Malta with 2.6.26-rc1:

  MODPOST 1516 modules
ERROR: "empty_zero_page" [fs/ext4/ext4dev.ko] undefined!

Any idea?  A missing export?
-- 
Martin Michlmayr
http://www.cyrius.com/
