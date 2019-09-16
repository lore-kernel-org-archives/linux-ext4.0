Return-Path: <SRS0=+K+T=XL=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9807C4CECD
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Sep 2019 23:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE9CB206A4
	for <linux-ext4@archiver.kernel.org>; Mon, 16 Sep 2019 23:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=codon.org.uk header.i=@codon.org.uk header.b="igFAFz0e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfIPXLV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 16 Sep 2019 19:11:21 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:47261 "EHLO
        cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfIPXLV (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Sep 2019 19:11:21 -0400
X-Greylist: delayed 516 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Sep 2019 19:11:20 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=codon.org.uk; s=63138784; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=m5qWHup7yMMRh+Xg8+te9WQq6zFrV6E62rs1+Nh3VZQ=; b=igFAFz0eoVGQ2XdTqJANa+aWw
        CkpAOZ1OLnw+jHLANskDhQ2CReJm0AvSvKfJ1APBgoulDhd4A9ZshFMN24saMu99lw+F6sqJmPtq+
        WAzpJTLqUx3ZSofM2WibAFe1gKB6ISfkxY+p6lWHlSKdZ9tMR11VlaSGwNji8+tIs387o=;
Received: from mjg59 by cavan.codon.org.uk with local (Exim 4.89)
        (envelope-from <mjg59@cavan.codon.org.uk>)
        id 1iA099-0001lM-MQ; Tue, 17 Sep 2019 00:11:03 +0100
Date:   Tue, 17 Sep 2019 00:11:03 +0100
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Vito Caputo <vcaputo@pengaru.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        zhangjs <zachary@baishancloud.com>, linux-ext4@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Linux 5.3-rc8
Message-ID: <20190916231103.bic65ab4ifv7vhio@srcf.ucam.org>
References: <20190916014833.cbetw4sqm3lq4x6m@shells.gnugeneration.com>
 <20190916024904.GA22035@mit.edu>
 <20190916042952.GB23719@1wt.eu>
 <CAHk-=wg4cONuiN32Tne28Cg2kEx6gsJCoOVroqgPFT7_Kg18Hg@mail.gmail.com>
 <20190916061252.GA24002@1wt.eu>
 <CAHk-=wjWSRzTjwN9F5gQcxtPkAgaRHJOOOTUjVakqP-Nzg9BXA@mail.gmail.com>
 <20190916172117.GB15263@mit.edu>
 <CAHk-=wgs65hez6ctK7J2k46BdQzvKU5avExPOTTJsZu6iqA-ow@mail.gmail.com>
 <20190916230217.vmgvsm6o2o4uq5j7@srcf.ucam.org>
 <CAHk-=whwSt4RqzqM7cA5SAhj+wkORfr1bG=+yydTJPtayQ0JwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whwSt4RqzqM7cA5SAhj+wkORfr1bG=+yydTJPtayQ0JwQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Sep 16, 2019 at 04:05:47PM -0700, Linus Torvalds wrote:
> On Mon, Sep 16, 2019 at 4:02 PM Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > Changing the default (even with kernel warnings) seems like
> > it risks people generating keys from an unseeded prng, and that seems
> > like a bad thing?
> 
> I agree that it's a horrible thing, but the fact that the default 0
> behavior had that "wait for entropy" is what now causes boot problems
> for people.

In one case we have "Systems don't boot, but you can downgrade your 
kernel" and in the other case we have "Your cryptographic keys are weak 
and you have no way of knowing unless you read dmesg", and I think 
causing boot problems is the better outcome here.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
