Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA94723C503
	for <linux-ext4@vger.kernel.org>; Tue,  4 Aug 2026 09:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785835919; cv=none; b=gf90F/994iJ8mLRjaeI2bUroFn9076FfhFn7gX0DVOPHbPmbDSWcbr4s7TMtXUCeAuI6E+0W08mEnzz5upL+m441CH64uvKq2RTbba1tAaCLgo6amzzMJJd089lltjUN4FAHI5w88lvfHLfowoeMrnu2+O6jEv3spBJRJyceC9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785835919; c=relaxed/simple;
	bh=eDmG5lDakZCXwLFMeNc+mswspbSEcDUo9QfhA2r5xwY=;
	h=Message-ID:Date:From:To:Cc:Subject:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TnzrlKCe2CHXSN0dl6wpOiWNjOl30ukuXCV04P0Fq901F7ecqutsdCiv8WFnCdeKDQq4BpSvSFMte2xqjNA45sSPaysCDw4Bq+dwtsGKLBlIPn5D10pkO2VMV6sqO5A7r9ZgeHtkaWSQfWogeAFXlU5yVoX8Q8XAVK6tDm+zSUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=egRUYpph; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="egRUYpph"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1785835905; bh=d51BcM29y2nxQKQ+BLvU3JeBTDkporK+Y/rVbaO95mg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=egRUYpphbrc6dg0Fbz5FeFPfSdc2bpvR43zGNaknT18Jy1ovklEw0Kth1u0IkMiAH
	 oQZ4LcaSryAelLFRUmV4s8D5U9l2YPddY30XefzuVYHkPQJD57rs03sK9cWSMprlBG
	 DpsPzdmGqKyGEqR6n07QuioeCMIV7Hqy2O1GGnsQ=
Received: from DESKTOP-AT5F202.localdomain ([183.242.132.32])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 7EAB5081; Tue, 04 Aug 2026 17:31:42 +0800
X-QQ-mid: xmsmtpt1785835902tjbvmbnn4
Message-ID: <tencent_0FC27986A042A6191B579D4A9E5FBA1ABB09@qq.com>
X-QQ-XMAILINFO: MeftnG8iNguN+NiNjOCbjVF/0UuLZc0HAVsolX7jbJlYQdUXqLf/5uavahV/kr
	 lsbpscWJZhL97jja5QJI/nmEWw0HVa6l3MnN894xnJL+WJA4Rl0ma8zxZouu9cp34Z1oTbqJSJ/a
	 kvCbZ2jXdnwWs4/Ba6B/GGZ/RNBER6bRGHt1vHDU5swuzsBk9qw5SSFBVWJ/aG5JxazIJUj7WzUb
	 964bzGAIhhtIFr2/pecz+H7f3IMWs8F2yxWsiGz3oOvEAfX3/ciDWu/lT+Z6Hs8AE42Yjayu1Ve6
	 hdwftSAyb7MApjKZKiXRxDN0kvGKIjYreELcEBTc84Q4UjmFL/VNhUx/TTA4UrmHtPmmbZptf72L
	 0fqXKUrlT+VMjjIjKj3eABuhzRIv6OmFEWnOVLB8IwD8Et4WgkfXQNYBu9DgmX1zXWHpQr4+N0DW
	 ERkWCp1gvBYkWr1f6E8hJmYH2cK4NwKXko+lo6ovQ4mDKuYQWyAiLCphEWO7h//yBLqyhGkSltpD
	 ieLgRKFvOAGInP8Njnrc1/xaMSWsAV70PQLsqub2OizO27ZBbxq/0+RkvDoMEhopER+X0ntngoxl
	 8vejDkTcDvomZLe/rMXUbJL2E0H7tvzABoziFPNZc5+2rpsnOMjPoOJJ0+6SDccw7/Lgo00/cUC/
	 mTc8ooxfOvS21guYmaf0wn+7Kc4gHa//fdjxC54gqmg7a5lNTv6PnAZCCl0qtMo2jO37DAL4rejq
	 ykvx4NhY1byGKVQbRG7hh3pwFCKrT4MWBEmTADCWUXrCSRAIx3iiRbNI8dsJk9ms9Io1Lbko/5LB
	 jskVKsgEDTgkLJ4v3P3ynua1zfPUIk8/63txGsBmFLphYa2siFWIAqtJJNw+ot/1kA8AJ51u+UlK
	 q3ZgAh0Fu/gLTWh0OGwcknZg2xRVcwu9yip1S9U0eLhVh8bpsvsUZ6gCwuXytvkEzJscGnLqs+0k
	 quNe1JRyEKBffIonVx+4OS2mJatyqLvxCOhTRpr9oGAjQl7BSkuD6FXrwN7lU1ogGOLeWluSabzI
	 xbtfuGHM/NbFk/jwyK
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
Date: Tue, 4 Aug 2026 17:31:42 +0800
From: shuo chen <1289151713@qq.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org
Subject: Re: [RESEND PATCH] jbd2:remove unnecessary finish_wait call in
 jbd2_journal_wait_updates
X-OQ-MSGID: <anGxfrrhuFHFHAgr@DESKTOP-AT5F202.localdomain>
References: <tencent_AA7E2FDA8D68E1E3430F219A8C3DAB442508@qq.com>
 <xwlk2l2v7qbfdnuzjrqm3utqd55uzfgqttzetqfl4ffjmnbrdp@unafpyi34kf4>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xwlk2l2v7qbfdnuzjrqm3utqd55uzfgqttzetqfl4ffjmnbrdp@unafpyi34kf4>

On Mon, Aug 03, 2026 at 03:47:18PM +0200, Jan Kara wrote:
> On Mon 03-08-26 20:35:39, shuo chen wrote:
> > merge transaction and atomic_read(&transaction->t_updates) check.
> > remove redundant finish_wait call.
> > 
> > Signed-off-by: shuo chen <1289151713@qq.com>
> 
> The changelog should mention what is the motivation of the patch. Simple
> cleanup?
> 
> > ---
> >  fs/jbd2/transaction.c | 7 ++-----
> >  1 file changed, 2 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 5cc7d097b2ac..0f193d02a054 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -831,15 +831,12 @@ void jbd2_journal_wait_updates(journal_t *journal)
> >  		 */
> >  		transaction_t *transaction = journal->j_running_transaction;
> >  
> > -		if (!transaction)
> > +		if (!transaction || !atomic_read(&transaction->t_updates))
> >  			break;
> >  
> >  		prepare_to_wait(&journal->j_wait_updates, &wait,
> >  				TASK_UNINTERRUPTIBLE);
> > -		if (!atomic_read(&transaction->t_updates)) {
> > -			finish_wait(&journal->j_wait_updates, &wait);
> > -			break;
> > -		}
> > +
> 
> This introduces a race with stop_this_handle() possibly causing a lost
> wakeup (I can see Sashiko noticed as well).
Thank you for the review.
After reconsideration, I realized this patch actually causes a lost wakeup 
in some scenarios, so it should be withdrawn.
I will withdraw this patch. Sorry for the noise,and thank you for your time.
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

