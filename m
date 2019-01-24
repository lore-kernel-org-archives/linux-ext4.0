Return-Path: <SRS0=8KOi=QA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19AFC282C6
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 08:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B154E218A3
	for <linux-ext4@archiver.kernel.org>; Thu, 24 Jan 2019 08:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfAXIfk (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:35:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:33366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725939AbfAXIfj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 24 Jan 2019 03:35:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 42B44AC17;
        Thu, 24 Jan 2019 08:35:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E82811E3FF5; Thu, 24 Jan 2019 09:35:36 +0100 (CET)
Date:   Thu, 24 Jan 2019 09:35:36 +0100
From:   Jan Kara <jack@suse.cz>
To:     Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nvme@lists.infradead.org, jack@suse.com, david@fromorbit.com,
        tytso@mit.edu, prakash.v@samsung.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/4] introduce four macros for in-kernel hints
Message-ID: <20190124083536.GB12184@quack2.suse.cz>
References: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
 <CGME20190109153336epcas2p29b3275b6c545e483a3f43b92268f08bf@epcas2p2.samsung.com>
 <1547047861-7271-3-git-send-email-joshi.k@samsung.com>
 <B4980620-2CFF-41C1-8EE7-C33F1FE431C0@javigon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B4980620-2CFF-41C1-8EE7-C33F1FE431C0@javigon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed 23-01-19 19:27:12, Javier González wrote:
> 
> > On 9 Jan 2019, at 16.30, Kanchan Joshi <joshi.k@samsung.com> wrote:
> > 
> > Exiting write-hints are exposed to user-mode. There is a possiblity
> > of conflict if kernel happens to use those. This patch introduces four
> > write-hints for exclusive kernel-mode use.
> > 
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > ---
> > include/linux/fs.h | 5 +++++
> > 1 file changed, 5 insertions(+)
> > 
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 811c777..e8548eb 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -291,6 +291,11 @@ enum rw_hint {
> > 	WRITE_LIFE_MEDIUM	= RWH_WRITE_LIFE_MEDIUM,
> > 	WRITE_LIFE_LONG		= RWH_WRITE_LIFE_LONG,
> > 	WRITE_LIFE_EXTREME	= RWH_WRITE_LIFE_EXTREME,
> > +/* below ones are meant for in-kernel use */
> > +	KERN_WRITE_LIFE_SHORT,
> > +	KERN_WRITE_LIFE_MEDIUM,
> > +	KERN_WRITE_LIFE_LONG,
> > +	KERN_WRITE_LIFE_EXTREME
> > };
> > 
> 
> I think Jens and Dave meant kernel hints to go top down. This would also
> give space for supporting more hints / streams from both ends for user
> and kernel.

Yes, that was the idea however if I understand it right, the write hints do
not really have to be consistent boot-to-boot since they aren't stored
persistently by the disk, are they? If that's the case, it doesn't really
matter which numbers we pick.

One thing I don't quite like is the naming of KERN_WRITE_LIFE_SHORT etc.. It
is upto filesystem to assign meanings to the write hints. So I think it is
enough to provide something like KERN_WRITE_HINT_MIN which is the first
hint available to the kernel and then the number of hints available to the
kernel.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
