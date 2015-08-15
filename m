From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4, jbd2: ensure entering into panic after recording
 an error in JBD2 superblock
Date: Sat, 15 Aug 2015 14:05:34 -0400
Message-ID: <20150815180534.GD22485@thunk.org>
References: <302309021.645571439185489165.JavaMail.weblogic@epmlwas07d>
 <20150815152036.GA22485@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"daehojng@gmail.com" <daehojng@gmail.com>
To: Daeho Jeong <daeho.jeong@samsung.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60518 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbbHOSFh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 15 Aug 2015 14:05:37 -0400
Content-Disposition: inline
In-Reply-To: <20150815152036.GA22485@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 15, 2015 at 11:20:36AM -0400, Theodore Ts'o wrote:
> On Mon, Aug 10, 2015 at 05:44:49AM +0000, Daeho Jeong wrote:
> > If a EXT4 filesystem utilizes JBD2 journaling and an error occurs, the journaling
> > will be aborted first and the error number will be recorded into JBD2 superblock
> > and, finally, the system will enter into the panic state in "errors=panic" option.
> > But, in the rare case, this sequence is little twisted like the below figure and
> > it will happen that the system enters into panic state, which means the system
> > reset in mobile environment, before completion of recording an error in the
> > journal superblock. In this case, e2fsck cannot recognize that the filesystem
> > failure occured in the previous run and the corruption wouldn't be fixed.
> 
> Applied, but please note that the patch was very badly whitespace
> damaged, *despite* being base64 encoded.  I had to manually apply the
> patch.  I also adjusted the commit description so that its width was
> no more 80 columns (ideally the width should be no more than 72
> columns wide).

.... and this commit causes the kernel to wedge hard with xfstests
generic/081.  So I'm going to drop this patch.

As I believe I mentioned before, please consider using xfstests as
part of your development work flow; it will save both you and me time.

Thanks,

							- Ted
