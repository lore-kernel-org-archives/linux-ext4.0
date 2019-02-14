Return-Path: <SRS0=5TFS=QV=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355DAC43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 19:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04639222D4
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Feb 2019 19:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="Dgi7E24D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405862AbfBNTbh (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Feb 2019 14:31:37 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36089 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391893AbfBNTbg (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 14 Feb 2019 14:31:36 -0500
Received: by mail-ot1-f68.google.com with SMTP id v62so3683768otb.3
        for <linux-ext4@vger.kernel.org>; Thu, 14 Feb 2019 11:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6hh3SEckQg9xIoEEZdgKNbHG/nekuwU+MMr5nG44uRE=;
        b=Dgi7E24DlYGDeKMhJfMg0JiqZl3yjddp15jEv2LJzNrwQ7d8hFMtXrmoa+1JMRRyaB
         PItFSZfsxkgmEh7z7L1aQ6Itd8sOPxca7+KsZiRnPjjyPls7G/9EDsU4HalW9OVs0vkW
         m9rV6hTdUObI/4LDAy1g45GIW1eK9vbmpeCnCVarn8nvT7T4jUq/wlrnnfMZnOKbpmA/
         tgH5LKIFGb696c7XCdfK1UNc28p+i+wNw/5oeD/5Yg3ucME04xWUgOx4+AB+mQSL0q+l
         xZYk5YsBFIHaJtr8XnwDEj4M9T/bMDKHNCGyJKSVJ8ISraT5XassuQmSpT26WRVTZ5d1
         Ffbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6hh3SEckQg9xIoEEZdgKNbHG/nekuwU+MMr5nG44uRE=;
        b=X0cVRYoPuB0X+i3TwtUlLKR+Lv9DlFbDzMe1Q5oCK0kvQBlBUG+eksttN0K2Wnph7Z
         dKJh5fN8UVYuRTWe4DQSLSZvYw/lCiwDdhULSRAxox0wclsNCh9nkuyzInfiiYsEMmV9
         Glok1WR6fJoKuXAZhD5o7/nGo3LwBtNZRX7RF48rj2NDzS1GP7/FeJGg1c5ux9WPeSV5
         2BukLvBP2LZYyqhOAWJbVP3L4UgMIgjloXtxMr9wHsJaagBqSiorDaREspB3vMITtu/o
         yYQa22Y/R81SqPiltzSo/EvylgV6LMUo5LE4XZSB6M35q2CqX92rxt6m3HSYRdIPY5U1
         wd0Q==
X-Gm-Message-State: AHQUAuYNqNO3QvsSFHY1JWhGN4Ubwk5rh1eZMVNaHh2Sr4Iyl9skD4Wq
        bDFOmykxiiG/P94nNj9Li+nmVN0IYSXNrTXJhQZB4Q==
X-Google-Smtp-Source: AHgI3IZ8azzb9ZBgMZI2fhPVHGsfvkZPP8OXTFKOuuvxbK5ss6InpEvsCxN5opRiqtgwbLdEWtj26BWaA0f7CSa52zY=
X-Received: by 2002:a05:6808:344:: with SMTP id j4mr3509094oie.149.1550172695679;
 Thu, 14 Feb 2019 11:31:35 -0800 (PST)
MIME-Version: 1.0
References: <CAPcyv4jyCDJTpGZB6qVX7_FiaxJfDzWA1cw8dfPjHM2j3j3yqQ@mail.gmail.com>
 <20190214134622.GG4525@dhcp22.suse.cz> <CAPcyv4gxFKBQ9eVdn+pNEzBXRfw6Qwfmu21H2i5uj-PyFmRAGQ@mail.gmail.com>
 <20190214191013.GA3420@redhat.com>
In-Reply-To: <20190214191013.GA3420@redhat.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 14 Feb 2019 11:31:24 -0800
Message-ID: <CAPcyv4jLTdJyTOy715qvBL_j_deiLoBmu_thkUnFKZKMvZL6hA@mail.gmail.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] The end of the DAX experiment
To:     Jerome Glisse <jglisse@redhat.com>
Cc:     Michal Hocko <mhocko@kernel.org>,
        lsf-pc@lists.linux-foundation.org,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Feb 14, 2019 at 11:10 AM Jerome Glisse <jglisse@redhat.com> wrote:
>
> On Thu, Feb 14, 2019 at 10:25:07AM -0800, Dan Williams wrote:
> > On Thu, Feb 14, 2019 at 5:46 AM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Wed 06-02-19 13:12:59, Dan Williams wrote:
> > > [...]
> > > > * Userfaultfd for file-backed mappings and DAX
> > >
> > > I assume that other topics are meant to be FS track but this one is MM,
> > > right?
> >
> > Yes, but I think it is the lowest priority of all the noted sub-topics
> > in this proposal. The DAX-reflink discussion, where a given
> > physical-page may need to be mapped into multiple inodes at different
> > offsets, might be more fruitful to have as a joint discussion with MM.
>
> Note that my generic page write protection work can be use for that ie
> having a single page correspond to multiple different mapping with also
> different offset within each mapping. While in my patchset i only solve
> the mapping aliasing issue, the index can be solve in much the same way
> because same thinking apply. Namely that when you work on a file you
> know the mapping and file offset and thus the index and when you work on
> the vma you know the mapping and offset within the vma which translate
> to offset within the file. They are only few places that do not have the
> informations available and those do not care about it.
>
> I am just again working on my struct page mapping patchset as well as
> the generic page write protection that sits on top. I hope to be able
> to post the v2 in couple weeks. You can always look at my posting last
> year to see more details.

Yes, I have that in mind as one of the contenders. However, it's not
clear to me that its a suitable fit for filesystem-reflink. Others
have floated the 'page proxy' idea, so it would be good to discuss the
merits of the general approaches.
