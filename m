Return-Path: <SRS0=Vv4O=SE=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C358C4360F
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 21:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AFD720856
	for <linux-ext4@archiver.kernel.org>; Tue,  2 Apr 2019 21:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=dilger-ca.20150623.gappssmtp.com header.i=@dilger-ca.20150623.gappssmtp.com header.b="Iy86cmQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfDBVxs (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 2 Apr 2019 17:53:48 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42448 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfDBVxs (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Apr 2019 17:53:48 -0400
Received: by mail-pf1-f195.google.com with SMTP id r15so7017570pfn.9
        for <linux-ext4@vger.kernel.org>; Tue, 02 Apr 2019 14:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=3VLKS0IvWMuilzMDU2UjrGzYf/s69s47gVVN3YSVjtw=;
        b=Iy86cmQArLxdTFtaa/4r2SLq0QsQEnWXd61HhAURuDpszGSgOGsvqK9F71Sb5c3yDK
         4XgtICr9xDATTRtJDHQz+S5jBSDKblyocxkeYVw/7DgDsspK/HlOHoShqkwbWU0JBVcp
         swFUgsT5xbH6yf8y9rUiCM/tOYi7ldhNFai2kvWRN9tv45jzgMRBiIkTYQCTp36MfmWU
         CsC99dojTNdTAbRm6V+BbSer7WxnGxcibCvTp3qGvndNzkXdEH/a/+b4l3g1Za/IVd0a
         m69wjfiH3+XZvysDs6yMZAzEnCwLqK0FgkJvNqdnKPSJAvc3gjBdH6UZrWwdloE7QnQX
         9y0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=3VLKS0IvWMuilzMDU2UjrGzYf/s69s47gVVN3YSVjtw=;
        b=O0uBN3OjJNUU3KSChEaPzUD0FlQqpeuu5MUN1OhcSN4CaiKqkdXg8PP3+TXb/Ac38d
         pIn6zkY95tWfpnC7c+sioNHvHKoZ96qI9qXqaLyTIN7eLwI36e1hSjQ/LjxsL3gNQHDw
         z9KXMt3X7XLrkeO2Z4297puY6+UmynnLMfnTD8+kKaMudeiAgwjKmbY5JRDkSk4+bRSP
         g3N1x5BYjVTi1wh6BeDjdaTRgt31OJpAw6IO44NL538ED7Q9uaQx9VivEIgv9eyV2sl8
         MDmR+lx0sWQUi9hjqD1XsHeCpS3JjrlZ/51+a2VmRrXCt0JRZT61/7VPYA1cIukVHkNh
         R0WQ==
X-Gm-Message-State: APjAAAWDD8GbmrJ70Pln/8TUrEZMziZq4VYmgkmb732s8Ky2bwXKpH1K
        GC/yuhPVmedvjWY77hFLshxiTw==
X-Google-Smtp-Source: APXvYqyQ8frfyoujsz0werBio23gncHfP7K3jJ58YIM4oxoAGJVLlI8DcjZBGumWNmG+p8YKu1wGQg==
X-Received: by 2002:a63:465b:: with SMTP id v27mr51130342pgk.165.1554242026950;
        Tue, 02 Apr 2019 14:53:46 -0700 (PDT)
Received: from cabot-wlan.adilger.int (S0106a84e3fe4b223.cg.shawcable.net. [70.77.216.213])
        by smtp.gmail.com with ESMTPSA id p3sm24209170pfn.167.2019.04.02.14.53.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Apr 2019 14:53:46 -0700 (PDT)
From:   Andreas Dilger <adilger@dilger.ca>
Message-Id: <E2E8A5E4-D174-4E90-8D8F-F1D69E98F20E@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_D8A70B35-FA94-4D5A-A584-5EC534E16F63";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] bootfs: simple bootloader filesystem
Date:   Tue, 2 Apr 2019 15:52:59 -0600
In-Reply-To: <20190402045519.GK1173@magnolia>
Cc:     Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
References: <20190401070001.GJ1173@magnolia> <20190401214632.GS26298@dastard>
 <20190402045519.GK1173@magnolia>
X-Mailer: Apple Mail (2.3273)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


--Apple-Mail=_D8A70B35-FA94-4D5A-A584-5EC534E16F63
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Apr 1, 2019, at 10:55 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> 
> On Tue, Apr 02, 2019 at 08:46:32AM +1100, Dave Chinner wrote:
>> On Mon, Apr 01, 2019 at 12:00:01AM -0700, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>> 
>>> Does your computer use a bootloader which arrogantly declares that it can
>>> read boot files off a filesystem but isn't sophisticated enough even to
>>> recognize when that filesystem needs journal recovery?
>>> 
>>> Does your system software deployment program foolishly omit system calls
>>> to flush newly unwrapped packages to disk?  Do you sometimes wonder if
>>> they've forgotten that old maxim, "wait for the disk drive light to turn
>>> off /before/ you power down"?
>>> 
>>> Are your computer operators aggressively derpy?  Do they have a habit of
>>> leaving disk cables on the floor so they can trip over them twenty times
>>> a day?  Does this leave you with sad files full of zeroes?
>>> 
>>> If so, bootfs is for you!  This new filesystem type uses journalling to
>>> ensure metadata integrity, but forces all writes and directory tree
>>> updates to be synchronous, fsyncs files on close, and checkpoints its
>>> journal whenever a synchronization event happens.  Some allege this is
>>> very slow, but I've been able to max out the iops on both of my double
>>> height floppy drives!  In a power-cycling stress test, I found that the
>>> switch broke off in my hand before I lost any data.  This concept may
>>> sound terrible, but like any good crutch, it _is_ made of wood!
>>> 
>>> Singed-off-by: Darrick J. Wong <djwong@kernel.org>
>>  ^^^^^^^^^^
>> 
>> Ooooo - such a hot topic! Finally bootfs is more than just
>> we-really-should-do-this conference talk!
>> 
>> Looks good to me - with this we can finally move on from LILO....
> 
> When Ted is done laughing, I really would like to consider something
> like this to solve the problem of grub-style bootloaders requiring a
> lease on the blocks underneath a file with a term exceeding that of the
> running kernel.
> 
> We can probably skip the harsh synchronous writes in favor of fsync on
> close, but we would need to keep the critical component of checkpointing
> the journal on fsync and syncfs.

Wouldn't it be enough if Grub marked the file IMMUTABLE so that it didn't
get remapped/rewritten?  The RPM pre/post kernel update scripts already
have hooks to rerun grub and update /etc/grub.conf, so they should also
be able to handle set/clear of the immutable flag during upgrade.

Cheers, Andreas






--Apple-Mail=_D8A70B35-FA94-4D5A-A584-5EC534E16F63
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAlyj2bsACgkQcqXauRfM
H+DWkg//X1jYUiafEu+/scS71lJAVRIzn4JYpIbEHnfzCKYe+dsd9/UInxyYpJxY
t5+P57fnkAifscITGA8DO+N3u6KH/5w9XpK7s5r3jqjammsCw6fYS4KaG55Kl1J1
nww3gr63kAuADOEV/3Y98fA/40EJ6+kN7wSjRpVyJRRLxmvqCfNxqPBmSMtELOfw
xgBAAcR0fTMbXN1L6TdEAUirjODVbSS1Loq7oao4N1saKZE+uhiuf0bROjk7FFLn
/uBDUdUppwvS/jRlvgyjzhVfV7vQ7YdQ8rmgGPAz0hwnm906KmpANk94DEmOTWfd
XfrtCA3E9WwWrHB51g0Pbsr4+GM2lpER8Hobts7wlYW99CJzQjckc7Y3pvTntbCs
b0WsQ0mJpzRjTF1cm1Js2DGKney0WXMOnE0YrDoi7bAtL0Jx9ItU6FyzHtYXX1SJ
941QzkbW7HjNwgO9+UwRnMtkgZ5BSeUVRx2ag1OSHmW5P4NPiwm301hXXeZdgkqu
r+RWwV15MzHcfhIAzJ1765g8oas/4LETedWE3qnuMGeGgGahErSHjl7xfINNzDQt
uPu3iw7YaybQFj0sVsemj3/ZpW4/XEOhpGeKpoqAF/h90+a4EF8sKKZwXxTQMIhN
Drj2QbOzgNVE8UFUsM3dyucW42KMJQIzO8vgy25GTwGXvVukFIU=
=mAtL
-----END PGP SIGNATURE-----

--Apple-Mail=_D8A70B35-FA94-4D5A-A584-5EC534E16F63--
