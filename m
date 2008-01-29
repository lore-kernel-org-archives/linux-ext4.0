From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [GIT PULL] ext4 update
Date: Tue, 29 Jan 2008 22:54:03 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801292250110.14907@fbirervta.pbzchgretzou.qr>
References: <E1JJjMo-00011j-EU@closure.thunk.org> <20080129125307.GF6774@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59412 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645AbYA2VyE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2008 16:54:04 -0500
In-Reply-To: <20080129125307.GF6774@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jan 29 2008 07:53, Theodore Tso wrote:
>
>>fwiw, diffstat is confused by git's diff output; you need to use
>>'diffstat -p1'

I am seeing normal behavior:

22:52 sovereign:~/linux > git status
# On branch dev-pcidata-dvb
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       modified:   drivers/media/dvb/b2c2/flexcop-pci.c
#       modified:   drivers/media/dvb/ttpci/av7110.c
#       modified:   drivers/media/dvb/ttpci/budget-av.c
#       modified:   drivers/media/dvb/ttpci/budget-ci.c
#       modified:   drivers/media/dvb/ttpci/budget-patch.c
#       modified:   drivers/media/dvb/ttpci/budget.c
#       modified:   drivers/media/radio/radio-gemtek-pci.c
#       modified:   drivers/media/radio/radio-maestro.c
#       modified:   drivers/media/radio/radio-maxiradio.c
#       modified:   drivers/media/video/bt8xx/bttv-driver.c
#       modified:   drivers/media/video/cafe_ccic.c
#       modified:   drivers/media/video/cx23885/cx23885-core.c
#       modified:   drivers/media/video/cx88/cx88-mpeg.c
#       modified:   drivers/media/video/cx88/cx88-video.c
#       modified:   drivers/media/video/dpc7146.c
#       modified:   drivers/media/video/hexium_gemini.c
#       modified:   drivers/media/video/hexium_orion.c
#       modified:   drivers/media/video/meye.c
#       modified:   drivers/media/video/mxb.c
#       modified:   drivers/media/video/saa7134/saa7134-cards.c
#       modified:   drivers/media/video/stradis.c
#       modified:   drivers/media/video/zoran_card.c
#
22:52 sovereign:~/linux > git diff HEAD | diffstat
 dvb/b2c2/flexcop-pci.c        |    2 +-
 dvb/ttpci/av7110.c            |    4 ++--
 dvb/ttpci/budget-av.c         |    2 +-
 dvb/ttpci/budget-ci.c         |    4 ++--
 dvb/ttpci/budget-patch.c      |    2 +-
 dvb/ttpci/budget.c            |    2 +-
 radio/radio-gemtek-pci.c      |    3 +--
 radio/radio-maestro.c         |    2 +-
 radio/radio-maxiradio.c       |    2 +-
 video/bt8xx/bttv-driver.c     |    2 +-
 video/cafe_ccic.c             |    2 +-
 video/cx23885/cx23885-core.c  |    2 +-
 video/cx88/cx88-mpeg.c        |    2 +-
 video/cx88/cx88-video.c       |    2 +-
 video/dpc7146.c               |    4 ++--
 video/hexium_gemini.c         |    4 ++--
 video/hexium_orion.c          |    4 ++--
 video/meye.c                  |    2 +-
 video/mxb.c                   |    4 ++--
 video/saa7134/saa7134-cards.c |    2 +-
 video/stradis.c               |    2 +-
 video/zoran_card.c            |    2 +-
 22 files changed, 28 insertions(+), 29 deletions(-)
