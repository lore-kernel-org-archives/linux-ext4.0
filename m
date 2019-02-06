Return-Path: <SRS0=aCZM=QN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42406C282C2
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 16:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11C6F217F9
	for <linux-ext4@archiver.kernel.org>; Wed,  6 Feb 2019 16:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730566AbfBFQEa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 6 Feb 2019 11:04:30 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:46482 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727212AbfBFQEa (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Feb 2019 11:04:30 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id A028F27DB0B
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc:     tytso@mit.edu, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, sfrench@samba.org,
        darrick.wong@oracle.com, samba-technical@lists.samba.org,
        jlayton@kernel.org, bfields@fieldses.org, paulus@samba.org
Subject: Re: [PATCH RFC v5 00/11] Ext4 Encoding and Case-insensitive support
Organization: Collabora
References: <20190128213223.31512-1-krisman@collabora.com>
        <20190205181041.cdyt5jt7yrqswyy2@pali> <8736p2jbov.fsf@collabora.com>
        <20190206084752.nwjkeiixjks34vao@pali>
Date:   Wed, 06 Feb 2019 11:04:24 -0500
In-Reply-To: <20190206084752.nwjkeiixjks34vao@pali> ("Pali =?utf-8?Q?Roh?=
 =?utf-8?Q?=C3=A1r=22's?= message of
        "Wed, 6 Feb 2019 09:47:52 +0100")
Message-ID: <87sgx0hpiv.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

Pali Rohár <pali.rohar@gmail.com> writes:

> On Tuesday 05 February 2019 14:08:00 Gabriel Krisman Bertazi wrote:
>> Pali Rohár <pali.rohar@gmail.com> writes:
>> 
>> > On Monday 28 January 2019 16:32:12 Gabriel Krisman Bertazi wrote:
>> >> The main change presented here is a proposal to migrate the
>> >> normalization method from NFKD to NFD.  After our discussions, and
>> >> reviewing other operating systems and languages aspects, I am more
>> >> convinced that canonical decomposition is more viable solution than
>> >> compatibility decomposition, because it doesn't ignore eliminate any
>> >> semantic meaning, like the definitive case of superscript numbers.  NFD
>> >> is also the documented method used by HFS+ and APFS, so there is
>> >> precedent. Notice however, that as far as my research goes, APFS doesn't
>> >> completely follows NFD, and in some cases, like <compat> flags, it
>> >> actually does NFKD, but not in others (<fraction>), where it applies the
>> >> canonical form.  We take a more consistent approach and always do plain NFD.
>> >> 
>> >> This RFC, therefore, aims to resume/start conversation with some
>> >> stalkeholders that may have something to say regarding the normalization
>> >> method used.  I added people from SMB, NFS and FS development who
>> >> might be interested on this.
>> >
>> > Hello! I think that choice of NFD normalization is not right decision.
>> > Some reasons:
>> >
>> > 1) NFD is not widely used. Even Apple does not use it (as you wrote
>> >    Apple has own normalization form).
>> 
>> To be exact, Apple claims to use NFD in their specification [1] .
>
> Interesting...
>
>> What I
>> observed is that they don't ignore some types of compatibility
>> characters correctly as they should. For instance, the ff ligature is
>> decomposed into f + f.
>
> I'm sure that Apple does not do NFD, but their own invented normal form.
> Some graphemes are decomposed, and some not.
>
>> > 2) All filesystems which I known either do not use any normalization or
>> >    use NFC.
>> > 3) Lot of existing Linux application generate file names in NFC.
>> >
>> 
>> Most do use NFC.  But this is an internal representation for ext4 and it
>> is name preserving.
>
> Ok. I was in impression that it does not preserve original names, just
> like implementation in Apple's system, where char* passed to creat()
> does not appear in readdir().
>
>> We only use the normalization when comparing if names
>> matches and to calculate dcache and dx hashes.  The unicode standard
>> recomends the D forms for internal representation.
>
> Ok, this should be less destructive and less visible to userspace.
>
>> > 4) Linux GUI libraries like Qt and Gtk generate strings from key strokes
>> >    in NFC. So if user type file name in Qt/Gtk box it would be in NFC.
>> >
>> > So why to use NFD in ext4 filesystem if Linux userspace ecosystem
>> > already uses NFC?
>> 
>> NFC is costlier to calculate, usually requiring an intermediate NFD
>> step.  Whether it is prohibitively expensive to do in the dcache path, I
>> don't know, but since it is a critical path, any gain matters.
>> 
>> > NFD here just makes another layer of problems, unexpected things and
>> > make it somehow different.
>> 
>> Is there any case where
>>    NFC(x) == NFC(y) && NFD(x) != NFD(y)   , or
>>    NFC(x) != NFC(y) && NFD(x) == NFD(y)
>
> This is good question. And I think we should get definite answer for it
> prior inclusion of normalization into kernel.
>
>> I am having a hard time thinking of an example.  This is the main
>> (only?) scenario where choosing C or D form for an internal
>> representation would affect userspace.
>
> For decision between normal format, probably yes.
>
>> >
>> > Why not rather choose NFS? It would be more compatible with Linux GUI
>> > applications and also with Microsoft Windows systems, which uses NFC
>> > too.
>> >
>> > Please, really consider to not use NFD. Most Linux applications really
>> > do not do any normalization or do NFC. And usage of decomposition form
>> > for application which do not implement full Unicode grapheme algorithms
>> > just make for them another problems.
>> 
>> > Yes, there are still lot of legacy application which expect that one
>> > code point = one visible symbol (therefore one Unicode grapheme). And
>> > because GUI in most cases generates NFC strings, also existing file
>> > names are in NFC, these application works in most cases without problem.
>> > Force usage of NFD filenames just break them.
>> 
>> As I said, this shouldn't be a problem because what the application
>> creates and retrieves is the exact name that was used before, we'd
>> only use this format for internal metadata on the disk (hashes) and for
>> in-kernel comparisons.
>
> There is another problem for userspace applications:
>
> Currently ext4 accepts as file name any sequence of bytes which do not
> contain nul byte and '/'. So having Latin1 file name is perfectly
> correct.
>
> What would happen if userspace application want to create following two
> file names? "\xDF" and "\F0"? First one is sharp S second one is eth (in
> Latin1). But file names are invalid UTF-8 sequences. Is it disallowed to
> create such file names? Or both file names are internally converted to
> "U+FFFD" (replacement character) and because NFD(first U+FFFD) ==
> NFD(second U+FFFD) only first file would be created?
>
> And what happen in general with invalid UTF-8 sequences? Because there
> are many different types of invalid UTF-8 sequences, like non-shortest
> sequence for valid code point, valid sequence for invalid code points
> (either surrogate pairs code points, or code points above U+10FFFF,
> ...), incorrect byte which should start new code point, incorrect byte
> when decoding of code point started, ...
>
> Different (userspace) application handles these invalid UTF-8 sequences
> differently, some of them accept some kind of "incorrectness" (e.g.
> non-shortest form of code point representation), some not. Some
> applications replace invalid parts of UTF-8 sequence by sequence of
> UTF-8 replacement character, some not. Also it can be observed that some
> applications use just one replacement characters and some other replace
> invalid UTF-8 sequence by more replacement characters.
>
> So trying to "recover" from invalid UTF-8 sequence to valid one is done
> in more ways... And usage of any existing way could cause problems...
> E.g. not possible to create two files "\xDF\xF0" and "\xF0\xDF"...

Basically there are 2 ways to sanely handle invalid utf-8 sequences
inside the kernel.  I don't see much gain in handling different levels
of incorrectness.  Opening up to "we now accept surrogate characters,
but reject unmapped code points (which we must do, because of stability
of future unicode versions)", makes everything much more unpredictable.

Anyway, two ways to handle invalid sequences...

  - 1. An invalid filename can't exist in the disk.  This means
    reject the sequence and fail the syscall when coming from the
    userspace, and flagging it as an error to be fixed by fsck when
    identifying any of these sequences already on the disk.  This has
    obvious backward compatibility problems with applications that want
    to create filenames with invalid sequences.

  - 2. An invalid filename can exist in the disk as a unique sequence.
    In this case, we must decide how to handle invalid sequences that
    eventually will appear.  The only sane way is to consider the entire
    sequence an opaque byte sequence, essentially falling back to the
    old behavior, which prevents userspace breakage.  We loose the
    normalization/casefold feature for that directory entry only, but
    the file is still accessible when using the exact match.

Any variant of these, like trying to fix invalid sequences or trying to
do a partial normalization/casefold as a best effort are insane to do in
kernel space.

Patch 09 already implements both of the sane behaviors.  Through a
flag in the file system, which defaults to the second case, ext4 will
either reject or treat invalid sequences as opaque byte sequences.

There are more details about handling of invalid sequences in the patch
description.

-- 
Gabriel Krisman Bertazi
