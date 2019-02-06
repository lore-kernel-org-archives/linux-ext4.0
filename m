Return-Path: <SRS0=aCZM=QN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F93BC282C2
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 08:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 020602081B
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 08:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qaZwiY7l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfBFIr5 (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Feb 2019 03:47:57 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45960 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbfBFIr4 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2019 03:47:56 -0500
Received: by mail-wr1-f66.google.com with SMTP id q15so6512198wro.12;
        Wed, 06 Feb 2019 00:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=EzRGcyagcgO9UHYNSCtbrtzelBfnAKDDhZdhBUxDdtI=;
        b=qaZwiY7lGhQbefTR5YE+PPBA7bDkdtkmiUhb9/dPFyjA6pHfkfvOz9iBua1BjOxy37
         KefsLUjTv0w+nQ4kbW++iv4h6ZQqEgXfuo4FgRDVnQ2RzUBXgZUYg3HxA3SzP/jiCK0D
         1mj8zRKPDThNRhH/rZzlFWE8UqGFcrcrwxm4R/41gwNFFpkTA6iqU40Gz4lHOCFBDcls
         y0k1Q/q9W7TP/CI+KsSVVfWIDcXoFx9rlamvU2YQbxD8ofG0BLpw7aWauj2L0eDXV0Hs
         A3ZTWUyLhqOYWiIqh0keFCnP1RnpnMNqGaZi/h4/zCEeJaciFW76VBxGoSGf6sDnHri0
         C7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=EzRGcyagcgO9UHYNSCtbrtzelBfnAKDDhZdhBUxDdtI=;
        b=N7y8MfakK5I6XjOw5Jy9agmUYGCZhtyKnZPyji4lbngpW/waHHNpbhXIX3nczdphjX
         MqSPKaLyYwN1We8PUW23ZkbrtB7lbJLv7WoZc7r/S1aZ9JX94ASz3ydBuQQTCgAdEsyi
         d/3gWfin126nSk7FIt7GAYm2ys3GVlZUmpCHccxV6EtqvoowBkKHqVInxePBNge3V5mi
         kVEsBmQB4Yz79WbIwBKqFifWpRBnUxKoijiNMr3XUum5Y/QV+KtREt6HGIx2FKkHgdgq
         dv5NrCPixeuahdWh59C5YucCXy/BqZntO10RzrcQyx2gzkXz8PmqZyOOklAbL/Czo2pd
         f3CA==
X-Gm-Message-State: AHQUAuaVG/qGLhfWuafmIhikesGavdQ745ja4uCJMqqOWl83KbnGfxar
        fhFdnha9Ovsb6pLuQVZo620=
X-Google-Smtp-Source: AHgI3IYzQjlXO8dFz2IcBuXWdrEHDHOyTCfnWliUNbQmNneNdr5TCO+vn8jlNP0/uwpXqatM+kynAw==
X-Received: by 2002:adf:d089:: with SMTP id y9mr7199512wrh.22.1549442874152;
        Wed, 06 Feb 2019 00:47:54 -0800 (PST)
Received: from pali ([2a02:2b88:2:1::5cc6:2f])
        by smtp.gmail.com with ESMTPSA id q1sm9175940wrs.89.2019.02.06.00.47.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 06 Feb 2019 00:47:53 -0800 (PST)
Date:   Wed, 6 Feb 2019 09:47:52 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, samba-technical@lists.samba.org,
        jlayton@kernel.org, bfields@fieldses.org, paulus@samba.org
Subject: Re: [PATCH RFC v5 00/11] Ext4 Encoding and Case-insensitive support
Message-ID: <20190206084752.nwjkeiixjks34vao@pali>
References: <20190128213223.31512-1-krisman@collabora.com>
 <20190205181041.cdyt5jt7yrqswyy2@pali>
 <8736p2jbov.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8736p2jbov.fsf@collabora.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tuesday 05 February 2019 14:08:00 Gabriel Krisman Bertazi wrote:
> Pali Rohár <pali.rohar@gmail.com> writes:
> 
> > On Monday 28 January 2019 16:32:12 Gabriel Krisman Bertazi wrote:
> >> The main change presented here is a proposal to migrate the
> >> normalization method from NFKD to NFD.  After our discussions, and
> >> reviewing other operating systems and languages aspects, I am more
> >> convinced that canonical decomposition is more viable solution than
> >> compatibility decomposition, because it doesn't ignore eliminate any
> >> semantic meaning, like the definitive case of superscript numbers.  NFD
> >> is also the documented method used by HFS+ and APFS, so there is
> >> precedent. Notice however, that as far as my research goes, APFS doesn't
> >> completely follows NFD, and in some cases, like <compat> flags, it
> >> actually does NFKD, but not in others (<fraction>), where it applies the
> >> canonical form.  We take a more consistent approach and always do plain NFD.
> >> 
> >> This RFC, therefore, aims to resume/start conversation with some
> >> stalkeholders that may have something to say regarding the normalization
> >> method used.  I added people from SMB, NFS and FS development who
> >> might be interested on this.
> >
> > Hello! I think that choice of NFD normalization is not right decision.
> > Some reasons:
> >
> > 1) NFD is not widely used. Even Apple does not use it (as you wrote
> >    Apple has own normalization form).
> 
> To be exact, Apple claims to use NFD in their specification [1] .

Interesting...

> What I
> observed is that they don't ignore some types of compatibility
> characters correctly as they should. For instance, the ff ligature is
> decomposed into f + f.

I'm sure that Apple does not do NFD, but their own invented normal form.
Some graphemes are decomposed, and some not.

> > 2) All filesystems which I known either do not use any normalization or
> >    use NFC.
> > 3) Lot of existing Linux application generate file names in NFC.
> >
> 
> Most do use NFC.  But this is an internal representation for ext4 and it
> is name preserving.

Ok. I was in impression that it does not preserve original names, just
like implementation in Apple's system, where char* passed to creat()
does not appear in readdir().

> We only use the normalization when comparing if names
> matches and to calculate dcache and dx hashes.  The unicode standard
> recomends the D forms for internal representation.

Ok, this should be less destructive and less visible to userspace.

> > 4) Linux GUI libraries like Qt and Gtk generate strings from key strokes
> >    in NFC. So if user type file name in Qt/Gtk box it would be in NFC.
> >
> > So why to use NFD in ext4 filesystem if Linux userspace ecosystem
> > already uses NFC?
> 
> NFC is costlier to calculate, usually requiring an intermediate NFD
> step.  Whether it is prohibitively expensive to do in the dcache path, I
> don't know, but since it is a critical path, any gain matters.
> 
> > NFD here just makes another layer of problems, unexpected things and
> > make it somehow different.
> 
> Is there any case where
>    NFC(x) == NFC(y) && NFD(x) != NFD(y)   , or
>    NFC(x) != NFC(y) && NFD(x) == NFD(y)

This is good question. And I think we should get definite answer for it
prior inclusion of normalization into kernel.

> I am having a hard time thinking of an example.  This is the main
> (only?) scenario where choosing C or D form for an internal
> representation would affect userspace.

For decision between normal format, probably yes.

> >
> > Why not rather choose NFS? It would be more compatible with Linux GUI
> > applications and also with Microsoft Windows systems, which uses NFC
> > too.
> >
> > Please, really consider to not use NFD. Most Linux applications really
> > do not do any normalization or do NFC. And usage of decomposition form
> > for application which do not implement full Unicode grapheme algorithms
> > just make for them another problems.
> 
> > Yes, there are still lot of legacy application which expect that one
> > code point = one visible symbol (therefore one Unicode grapheme). And
> > because GUI in most cases generates NFC strings, also existing file
> > names are in NFC, these application works in most cases without problem.
> > Force usage of NFD filenames just break them.
> 
> As I said, this shouldn't be a problem because what the application
> creates and retrieves is the exact name that was used before, we'd
> only use this format for internal metadata on the disk (hashes) and for
> in-kernel comparisons.

There is another problem for userspace applications:

Currently ext4 accepts as file name any sequence of bytes which do not
contain nul byte and '/'. So having Latin1 file name is perfectly
correct.

What would happen if userspace application want to create following two
file names? "\xDF" and "\F0"? First one is sharp S second one is eth (in
Latin1). But file names are invalid UTF-8 sequences. Is it disallowed to
create such file names? Or both file names are internally converted to
"U+FFFD" (replacement character) and because NFD(first U+FFFD) ==
NFD(second U+FFFD) only first file would be created?

And what happen in general with invalid UTF-8 sequences? Because there
are many different types of invalid UTF-8 sequences, like non-shortest
sequence for valid code point, valid sequence for invalid code points
(either surrogate pairs code points, or code points above U+10FFFF,
...), incorrect byte which should start new code point, incorrect byte
when decoding of code point started, ...

Different (userspace) application handles these invalid UTF-8 sequences
differently, some of them accept some kind of "incorrectness" (e.g.
non-shortest form of code point representation), some not. Some
applications replace invalid parts of UTF-8 sequence by sequence of
UTF-8 replacement character, some not. Also it can be observed that some
applications use just one replacement characters and some other replace
invalid UTF-8 sequence by more replacement characters.

So trying to "recover" from invalid UTF-8 sequence to valid one is done
in more ways... And usage of any existing way could cause problems...
E.g. not possible to create two files "\xDF\xF0" and "\xF0\xDF"...

> > (PS: I think that only 2 programming languages implements Unicode
> > grapheme algorithms correctly: Elixir and Perl 6; which is not so
> > much)
> 
> [1] https://developer.apple.com/support/apple-file-system/Apple-File-System-Reference.pdf
> 

-- 
Pali Rohár
pali.rohar@gmail.com
