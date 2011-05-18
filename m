From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/4 v3] e2image: Add support for qcow2 format
Date: Wed, 18 May 2011 18:20:38 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1105181819530.4100@dhcp-27-109.brq.redhat.com>
References: <1305718615-5991-1-git-send-email-lczerner@redhat.com> <1305718615-5991-2-git-send-email-lczerner@redhat.com> <20110518161751.GC29368@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org,
	sandeen@redhat.com, adilger@dilger.ca
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932730Ab1ERQUn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 May 2011 12:20:43 -0400
In-Reply-To: <20110518161751.GC29368@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 18 May 2011, Ted Ts'o wrote:

> On Wed, May 18, 2011 at 01:36:53PM +0200, Lukas Czerner wrote:
> > This commit adds support for exporting filesystem into QCOW2 image
> > format. Like sparse format this saves space, by writing only necessary
> > (metadata blocks) into image. Unlike sparse image, QCOW2 image is NOT
> > sparse, hence does not change its size by copying with not-sparse-aware
> > tools.
> > 
> > New options '-Q' has been added to tell the e2image to use QCOW2 as an
> > output image format. QCOW2 supports encryption and compression, however
> > e2image so far does no support such features, however you can still
> > scramble filenames with '-s' option.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> 
> Applied to the e2fsprogs branch, with a lot of whitespace fixes.
> 
> 	       		 	      	- Ted

Thanks Ted! And sorry for the whitespace problems, will do better next
time!

-Lukas
