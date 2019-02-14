Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A39C10F04
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 20:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB27E21B68
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 20:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jzgMym79"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405970AbfBNUIn (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 15:08:43 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52954 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391810AbfBNUIn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 15:08:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=3mwfpa8LNR+UOVANIfUHZaTtq+bD3XmZiQXOhtKUaYM=; b=jzgMym798e+z4CWQ3ts9zTomB
        uHV6QS0qAtJeDzNsTejixTR+SDHlduKxrcqrHiXyAO2Q/ULK7UvQwR0jVicPyjzPFUnrHrKHJ7GXk
        EJfHHxWsdgxwI+voRvnm8h5vfk5qogPwExo9oipC2mmm3rsej2CB1GGR8KvJrsrU0SdEb559cn5Bu
        pFnlYyCYXVb0fl62gI3kW4iM9QNtVjdf+WfL0PwrFNel4DubKhOirZQwfNhBGjK1DEuWCSaX3gYWh
        eW+lUsRanX1U/dg99zxiecdw7y81b8n3GSys5wIV68R9Uchj6/YzPUN7gGaLLIkL8H67YI6FQNDbV
        OVoaejwvg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1guNJI-0005oe-Vl; Thu, 14 Feb 2019 20:08:40 +0000
Date:   Thu, 14 Feb 2019 12:08:40 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jerome Glisse <jglisse@redhat.com>,
        Michal Hocko <mhocko@kernel.org>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
Message-ID: <20190214200840.GB12668@bombadil.infradead.org>
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz>
 <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
 <20190214191013.GA3420@redhat.com>
 <CAPcyv4jLTdJyTOy715qvBL_j_deiLoBmu_thkUnFKZKMvZL6hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jLTdJyTOy715qvBL_j_deiLoBmu_thkUnFKZKMvZL6hA@mail.gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 14, 2019 at 11:31:24AM -0800, Dan Williams wrote:
> On Thu, Feb 14, 2019 at 11:10 AM Jerome Glisse <jglisse@redhat.com> wrote:
> > I am just again working on my struct page mapping patchset as well as
> > the generic page write protection that sits on top. I hope to be able
> > to post the v2 in couple weeks. You can always look at my posting last
> > year to see more details.
> 
> Yes, I have that in mind as one of the contenders. However, it's not
> clear to me that its a suitable fit for filesystem-reflink. Others
> have floated the 'page proxy' idea, so it would be good to discuss the
> merits of the general approaches.

... and my preferred option of putting pfn entries in the page cache.
Or is that what you meant by "page proxy"?
