From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH v1 03/22] libext2fs: add functions to operate on extended
 attribute
Date: Mon, 14 Oct 2013 10:41:20 +0800
Message-ID: <20131014024120.GA12010@gmail.com>
References: <1375436989-18948-1-git-send-email-wenqing.lz@taobao.com>
 <1375436989-18948-4-git-send-email-wenqing.lz@taobao.com>
 <20130805173452.GA9203@blackbox.djwong.org>
 <20130805231434.GA3784@gmail.com>
 <20131014015526.GA25013@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:52781 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab3JNCje (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Oct 2013 22:39:34 -0400
Received: by mail-pb0-f48.google.com with SMTP id ma3so6636692pbc.7
        for <linux-ext4@vger.kernel.org>; Sun, 13 Oct 2013 19:39:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20131014015526.GA25013@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Oct 13, 2013 at 09:55:26PM -0400, Theodore Ts'o wrote:
> On Tue, Aug 06, 2013 at 07:14:34AM +0800, Zheng Liu wrote:
> > > > +ec	EXT2_ET_EXT_ATTR_CURRUPTED,
> > > > +	"Extended attribute currupted"
> > > 
> > > "corrupted".
> > 
> > Thanks for pointing it out.  Fix it in next spin.
> > 
> > > (Or maybe shorten that to "corrupt"?)
> > 
> > I find the 'CORRUPT' in lib/ext2fs/ext2_err.et.in, and the result are as
> > below.
> > 
> > It seems that there is no any rule about this.  I am wondering if we
> > need to rename _DIR_CORRUPTED to _DIR_CORRUPT.  I am ok for using
> > _CORRUPT or _CORRUPTED.
> 
> We shouldn't change existing error codes since that will break
> backwards compatibility.  My preference for the new error code is:
> 
> ec	  EXT2_ET_EXT_ATTR_CORRUPT,
> 	  "Corrupt Extended attribute"

Got it.

Thanks,
                                                - Zheng
