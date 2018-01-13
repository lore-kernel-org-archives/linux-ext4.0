From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Subject: Re: [PATCH RFC 03/13] charsets: utf8: Add unicode character database files
Date: Sat, 13 Jan 2018 02:28:05 -0200
Message-ID: <87wp0mqt62.fsf@collabora.co.uk>
References: <20180112071234.29470-1-krisman@collabora.co.uk>
        <20180112071234.29470-4-krisman@collabora.co.uk>
        <20180113002407.GD8249@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: david@fromorbit.com, bpm@sgi.com, olaf@sgi.com,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kernel@lists.collabora.co.uk, alvaro.soliverez@collabora.co.uk
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:47066 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965419AbeAME2M (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jan 2018 23:28:12 -0500
In-Reply-To: <20180113002407.GD8249@thunk.org> (Theodore Ts'o's message of
        "Fri, 12 Jan 2018 19:24:07 -0500")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Jan 12, 2018 at 05:12:24AM -0200, Gabriel Krisman Bertazi wrote:
>> From: Olaf Weber <olaf@sgi.com>
>> 
>> Add files from the Unicode Character Database, version 7.0.0, to the source.
>> A helper program that generates a trie used for normalization from these
>> files is part of a separate commit.
>
> It looks like the latest version of Unicode is 10.0.0.  Once we pick a
> Unicode version, changing will be painful; but in the absence of
> interop requirements, is there a reason to stick with Unicode 7?  Why
> not take the latest version of Unicode and then freeze on it?
>

Hi Ted,

No, there isn't a specific reason for unicode 7 and I forgot to mention
this in my cover letter.  I have successfully generated the data file
for 10.0.0 with the mkutf8data script, but I couldn't validate it
entirely yet.  I walked through changelogs to make sure any relevant
changes where there, but I'm not done yet.  You can definitely expect
new versions of the patchset to support 10.0.0.

Thanks,

-- 
Gabriel Krisman Bertazi
