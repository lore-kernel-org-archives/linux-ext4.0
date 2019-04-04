Return-Path: <SRS0=e1E2=SG=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF315C4360F
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 13:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E9142075E
	for <linux-ext4@archiver.kernel.org>; Thu,  4 Apr 2019 13:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov-name.20150623.gappssmtp.com header.i=@shutemov-name.20150623.gappssmtp.com header.b="gH2HKKrq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfDDNIp (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 4 Apr 2019 09:08:45 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44089 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfDDNIo (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Apr 2019 09:08:44 -0400
Received: by mail-lf1-f68.google.com with SMTP id v71so1715532lfa.11
        for <linux-ext4@vger.kernel.org>; Thu, 04 Apr 2019 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ydhQYDsYO5blITLWkKkMOKoBtLuqbWY/Tzn56seZhUY=;
        b=gH2HKKrq1I97KbmXoHT0RPv9oGKzcranbkpFUNclk2IQ/PlMg+i+bBHEhKoYTJXg4e
         LtoEjliHav/Yfdhpq1UclvTyx4s8eb3Dnx63eGac0SrVNZ930iHOldoOoYvwMld/TWrO
         1wADWyFBeJ7EmzZlulI+klB53ianLFmNr8Y+DXSCqjyLWSp3oank3TR+VTki5vnNNKUS
         TvBQPMbhiWn/99s0PdvOiuUnfeIPzy639yCVMFKMb1sPm+avXRlvtTlo4ZHWx/q9d/Gi
         H92iFBioHoQJuSTW5sPfJwpDnPV1tFj+tsZZoE1zhYEJVhfxwrq3185bw/gPAF7l2ILZ
         PhfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ydhQYDsYO5blITLWkKkMOKoBtLuqbWY/Tzn56seZhUY=;
        b=GeTOOKwWHJktGF5oadKk4HJEnfB6LRCTGHRadlzqoaJDfETQS1pmJYpXcolsTW5wY0
         nFuuRwcrcdiLtc0/coR8Rbn5QfW5FqJoLY8rAq0U3YU6SU33DuB281uk0VzWhgeRL2/m
         bWh8Nw9VF3NmO6Ymfmu15SVJRegcCl4bxNM5S64P1n45o8qqW/7kxj93pjvurNVfxZrV
         EDVclEw3RU1hSdi7rVgCyR1M/SDMZQX3Nvh9JXCkZKmrSYG960H04WUqaA9m0zh5LEZl
         hq/h0YFNX7fpXfpLKDMwDTEWAB4Ki9blrchquWnti2ZpjfnjlSH8Kirh03FxuEDhmRgg
         GEQQ==
X-Gm-Message-State: APjAAAVsZqxahjJkbwx5DY03Xxb3USQ/uZ9C57iBRmS3qIVmAqEFcMRE
        j+Zdp/EKKG7O45z0h9/UuCJKUMzw7/QdEQ==
X-Google-Smtp-Source: APXvYqzAwanZ+nskhouSYnB3oZZUeZzTzBAZAbOnXlbYnKQKzGspAQ0VLl1GDm/+7D/PYNzC/4Gt0g==
X-Received: by 2002:a19:5201:: with SMTP id m1mr3222474lfb.68.1554383322830;
        Thu, 04 Apr 2019 06:08:42 -0700 (PDT)
Received: from kshutemo-mobl1.localdomain ([178.127.198.154])
        by smtp.gmail.com with ESMTPSA id v26sm3970728lja.60.2019.04.04.06.08.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Apr 2019 06:08:41 -0700 (PDT)
Received: by kshutemo-mobl1.localdomain (Postfix, from userid 1000)
        id C004C30039B; Thu,  4 Apr 2019 16:08:39 +0300 (+03)
Date:   Thu, 4 Apr 2019 16:08:39 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Jan Kara <jack@suse.cz>
Cc:     bugzilla-daemon@bugzilla.kernel.org, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [Bug 203107] New: Bad page map in process during boot
Message-ID: <20190404130839.5tkpwihuct4mex32@kshutemo-mobl1>
References: <bug-203107-13602@https.bugzilla.kernel.org/>
 <20190402101613.GF12133@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190402101613.GF12133@quack2.suse.cz>
User-Agent: NeoMutt/20180716
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Apr 02, 2019 at 12:16:13PM +0200, Jan Kara wrote:
> Switching to email...
> 
> On Fri 29-03-19 20:46:22, bugzilla-daemon@bugzilla.kernel.org wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=203107
> > 
> >             Bug ID: 203107
> >            Summary: Bad page map in process during boot
> >            Product: File System
> >            Version: 2.5
> >     Kernel Version: 5.0.5
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: ext4
> >           Assignee: fs_ext4@kernel-bugs.osdl.org
> >           Reporter: echto1@gmail.com
> >         Regression: No
> > 
> > Error occurs randomly at boot after upgrading kernel from 5.0.0 to 5.0.4.
> > 
> > https://justpaste.it/387uf
> 
> I don't think this is an ext4 error. Sure this is an error in file mapping
> of libblkid.so.1.1.0 (which is handled by ext4) but the filesystem has very
> little to say wrt how or which PTEs are installed. And the problem is that
> invalid PTE (dead000000000100) is present in page tables. So this looks
> more like a problem in MM itself. Adding MM guys to CC.

0xdead000000000100 and 0xdead000000000200 are LIST_POISON1 and
LIST_POISON2 repectively. Have no idea how would they end up in page table.

-- 
 Kirill A. Shutemov
