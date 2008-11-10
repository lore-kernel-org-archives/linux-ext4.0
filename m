From: Greg KH <gregkh@suse.de>
Subject: Re: [patch 02/23] ext: Avoid printk floods in the face of
	directory corruption (CVE-2008-3528)
Date: Mon, 10 Nov 2008 10:06:56 -0800
Message-ID: <20081110180656.GA9795@suse.de>
References: <20081107224818.593212310@mini.kroah.org> <20081107231516.GC1108@kroah.com> <49179F8C.4050103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
	Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	ext4 development <linux-ext4@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Eugene Teo <eugeneteo@kernel.sg>
To: Eugene Teo <eteo@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56753 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbYKJSHS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Nov 2008 13:07:18 -0500
Content-Disposition: inline
In-Reply-To: <49179F8C.4050103@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 10, 2008 at 10:42:20AM +0800, Eugene Teo wrote:
> Greg KH wrote:
> 
> Please change the description of the bug to:
> 
> "A very large directory with many read failures (either due to storage
> problems, or due to invalid size & blocks from corruption) will generate
> a printk storm as the filesystem continues to try to read all the
> blocks. This flood of messages can tie up the box until it is complete -
> which may be a very long time, especially for very large corrupted values.
> 
> This is fixed by only reporting the corruption once each time we try to
> read the directory."
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commitdiff;h=bd39597

Hm, why would I change the description to be different from what the
developer asked it to be?  It references the specific changeset you
point to above already.  I'm inclined to stick with the text that the
developer asked to be used (especially as this is a combined 3
changesets into one patch).

Same thing goes for the 2.6.26-stable patch as well.

thanks,

greg k-h
