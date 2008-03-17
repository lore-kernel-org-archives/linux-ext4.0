From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] quota: Quota core changes for quotaon on remount
Date: Mon, 17 Mar 2008 14:17:56 +0100
Message-ID: <20080317131756.GC17307@duck.suse.cz>
References: <20080313125944.GF12523@duck.suse.cz> <20080313130412.GG12523@duck.suse.cz> <20080313144802.7397a048.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jengelh@computergmbh.de,
	mjt@tls.msk.ru
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39294 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752395AbYCQNR5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2008 09:17:57 -0400
Content-Disposition: inline
In-Reply-To: <20080313144802.7397a048.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 13-03-08 14:48:02, Andrew Morton wrote:
> On Thu, 13 Mar 2008 14:04:12 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > +static inline int DQUOT_ON_REMOUNT(struct super_block *sb)
> > +{
> > +	int cnt;
> > +	int ret = 0, err;
> > +
> > +	if (!sb->s_qcop || !sb->s_qcop->quota_on)
> > +		return -ENOSYS;
> > +	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> > +		err = sb->s_qcop->quota_on(sb, cnt, 0, NULL, 1);
> > +		if (err < 0 && !ret)
> > +			ret = err;
> > +	}
> > +	return ret;
> > +}
> > +  
> 
> That's about ten times too large to be inlined.  Oh well.
  Right, will send a cleanup patch. Thanks for spotting this.

> Sometime could you please take a look at uninlining some of the porkier
> functions in quotaops.h, and maybe convert them to lower case?
> 
> 
> For the latter we can do
> 
> 	#define DQUOT_ON_REMOUNT(sb) dquot_on_remount(sb)
> 
> etc, then remove those macros when everything has been converted and we've
> given any out-of-tree filesytem developers time to update, etc.
  Good idea. Will do.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
