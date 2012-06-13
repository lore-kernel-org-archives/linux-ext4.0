From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Wed, 13 Jun 2012 16:00:33 -0400
Message-ID: <20120613200033.GB17990@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <201206122007.28514.arnd.bergmann@linaro.org>
 <20120612204128.GF12161@thunk.org>
 <201206131944.35351.arnd.bergmann@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49655 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab2FMUAl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 16:00:41 -0400
Content-Disposition: inline
In-Reply-To: <201206131944.35351.arnd.bergmann@linaro.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 13, 2012 at 07:44:35PM +0000, Arnd Bergmann wrote:
> 
> I think using the inode number is a reasonable fit. Using the
> inode number of the parent directory might be more appropriate
> but it breaks with hard links and cross-directory renames (we
> must not use the same LBA with conflicting context numbers,
> or flush the old context inbetween).

I think the inode number of the parent directory by itself is actually
*not* a good idea, because there are plenty of cases where files in
the same directory do not have the same life time.  For example,
consider your openoffice files in ~/Documents, for example.  Or worse,
the files in ~/Downloads written by your web browser.

It might be worth considering the hueristic of a series of files
written by a single process close together in time as belonging to a
single context.  That still might not be quite right in the case of a
git checkout for example, most of the time I think that hueristic
would be quite valid.

One thing that *would* be worth consider when trying to decide the
right granularity for a context would be the size of the erase block.
If the erase block is 2 megs, and we are writing a lot of 8 meg files,
a per-inode context granularity probably makes a lot of sense.

OTOH, if the erase block size is 8mb, and we are writing a whole bunch
of small files, we probably want to use a much more aggressive way of
aggregating relating blocks than just "inodes" that average in size of
say, 32k or 128k.  Getting this information may requiring leaning
rather hard on the eMMC manufacturers, since they (irrationally, in my
opinion) think this should be trade secret information.  :-(

	       	    	      	    	   - Ted
