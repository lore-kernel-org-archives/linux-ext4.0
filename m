From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] quota: Quota core changes for quotaon on remount
Date: Thu, 13 Mar 2008 14:48:02 -0700
Message-ID: <20080313144802.7397a048.akpm@linux-foundation.org>
References: <20080313125944.GF12523@duck.suse.cz>
	<20080313130412.GG12523@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, jengelh@computergmbh.de,
	mjt@tls.msk.ru
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20080313130412.GG12523@duck.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 13 Mar 2008 14:04:12 +0100
Jan Kara <jack@suse.cz> wrote:

> +static inline int DQUOT_ON_REMOUNT(struct super_block *sb)
> +{
> +	int cnt;
> +	int ret = 0, err;
> +
> +	if (!sb->s_qcop || !sb->s_qcop->quota_on)
> +		return -ENOSYS;
> +	for (cnt = 0; cnt < MAXQUOTAS; cnt++) {
> +		err = sb->s_qcop->quota_on(sb, cnt, 0, NULL, 1);
> +		if (err < 0 && !ret)
> +			ret = err;
> +	}
> +	return ret;
> +}
> +  

That's about ten times too large to be inlined.  Oh well.

Sometime could you please take a look at uninlining some of the porkier
functions in quotaops.h, and maybe convert them to lower case?



For the latter we can do

	#define DQUOT_ON_REMOUNT(sb) dquot_on_remount(sb)

etc, then remove those macros when everything has been converted and we've
given any out-of-tree filesytem developers time to update, etc.

Thanks.
