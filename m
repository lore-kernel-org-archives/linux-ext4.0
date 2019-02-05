Return-Path: <SRS0=Sz5y=QM=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CBAC282CB
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 19:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 507EE2175B
	for <linux-ext4@archiver.kernel.org>; Tue,  5 Feb 2019 19:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726955AbfBETIG convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 5 Feb 2019 14:08:06 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41492 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbfBETIG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Feb 2019 14:08:06 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 648B82801D6
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc:     tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, samba-technical@lists.samba.org,
        jlayton@kernel.org, bfields@fieldses.org, paulus@samba.org
Subject: Re: [PATCH RFC v5 00/11] Ext4 Encoding and Case-insensitive support
In-Reply-To: <20190205181041.cdyt5jt7yrqswyy2@pali> ("Pali =?utf-8?Q?Roh?=
 =?utf-8?Q?=C3=A1r=22's?= message of
        "Tue, 5 Feb 2019 19:10:41 +0100")
Organization: Collabora
References: <20190128213223.31512-1-krisman@collabora.com>
        <20190205181041.cdyt5jt7yrqswyy2@pali>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Tue, 05 Feb 2019 14:08:00 -0500
Message-ID: <8736p2jbov.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Pali Rohár <pali.rohar@gmail.com> writes:

> On Monday 28 January 2019 16:32:12 Gabriel Krisman Bertazi wrote:
>> The main change presented here is a proposal to migrate the
>> normalization method from NFKD to NFD.  After our discussions, and
>> reviewing other operating systems and languages aspects, I am more
>> convinced that canonical decomposition is more viable solution than
>> compatibility decomposition, because it doesn't ignore eliminate any
>> semantic meaning, like the definitive case of superscript numbers.  NFD
>> is also the documented method used by HFS+ and APFS, so there is
>> precedent. Notice however, that as far as my research goes, APFS doesn't
>> completely follows NFD, and in some cases, like <compat> flags, it
>> actually does NFKD, but not in others (<fraction>), where it applies the
>> canonical form.  We take a more consistent approach and always do plain NFD.
>> 
>> This RFC, therefore, aims to resume/start conversation with some
>> stalkeholders that may have something to say regarding the normalization
>> method used.  I added people from SMB, NFS and FS development who
>> might be interested on this.
>
> Hello! I think that choice of NFD normalization is not right decision.
> Some reasons:
>
> 1) NFD is not widely used. Even Apple does not use it (as you wrote
>    Apple has own normalization form).

To be exact, Apple claims to use NFD in their specification [1] .  What I
observed is that they don't ignore some types of compatibility
characters correctly as they should. For instance, the ff ligature is
decomposed into f + f.

> 2) All filesystems which I known either do not use any normalization or
>    use NFC.
> 3) Lot of existing Linux application generate file names in NFC.
>

Most do use NFC.  But this is an internal representation for ext4 and it
is name preserving. We only use the normalization when comparing if names
matches and to calculate dcache and dx hashes.  The unicode standard
recomends the D forms for internal representation.

> 4) Linux GUI libraries like Qt and Gtk generate strings from key strokes
>    in NFC. So if user type file name in Qt/Gtk box it would be in NFC.
>
> So why to use NFD in ext4 filesystem if Linux userspace ecosystem
> already uses NFC?

NFC is costlier to calculate, usually requiring an intermediate NFD
step.  Whether it is prohibitively expensive to do in the dcache path, I
don't know, but since it is a critical path, any gain matters.

> NFD here just makes another layer of problems, unexpected things and
> make it somehow different.

Is there any case where
   NFC(x) == NFC(y) && NFD(x) != NFD(y)   , or
   NFC(x) != NFC(y) && NFD(x) == NFD(y)

I am having a hard time thinking of an example.  This is the main
(only?) scenario where choosing C or D form for an internal
representation would affect userspace.

>
> Why not rather choose NFS? It would be more compatible with Linux GUI
> applications and also with Microsoft Windows systems, which uses NFC
> too.
>
> Please, really consider to not use NFD. Most Linux applications really
> do not do any normalization or do NFC. And usage of decomposition form
> for application which do not implement full Unicode grapheme algorithms
> just make for them another problems.

> Yes, there are still lot of legacy application which expect that one
> code point = one visible symbol (therefore one Unicode grapheme). And
> because GUI in most cases generates NFC strings, also existing file
> names are in NFC, these application works in most cases without problem.
> Force usage of NFD filenames just break them.

As I said, this shouldn't be a problem because what the application
creates and retrieves is the exact name that was used before, we'd
only use this format for internal metadata on the disk (hashes) and for
in-kernel comparisons.

> (PS: I think that only 2 programming languages implements Unicode
> grapheme algorithms correctly: Elixir and Perl 6; which is not so
> much)

[1] https://developer.apple.com/support/apple-file-system/Apple-File-System-Reference.pdf

-- 
Gabriel Krisman Bertazi
