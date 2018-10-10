Return-Path: <SRS0=q/KL=MW=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34480 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbeJKDH2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Oct 2018 23:07:28 -0400
MIME-Version: 1.0
In-Reply-To: <20181010192658.GA27646@thunk.org>
References: <20181010142813.1918180-1-arnd@arndb.de> <20181010192658.GA27646@thunk.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 10 Oct 2018 21:43:39 +0200
Message-ID: <CAK8P3a0Ms--dFOA8Frz+SsBGHgrV9_uYvxg6G8YT+VhDBJZGeg@mail.gmail.com>
Subject: Re: [PATCH] ext4: avoid unused variable warning
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Eric Biggers <ebiggers@google.com>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/10/18, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Wed, Oct 10, 2018 at 04:27:58PM +0200, Arnd Bergmann wrote:
>> The two new variables are only used in an #ifdef, so they cause a
>> warning without CONFIG_QUOTA:
>>
>> fs/ext4/super.c: In function 'parse_options':
>> fs/ext4/super.c:1977:26: error: unused variable 'grp_qf_name'
>> [-Werror=unused-variable]
>>   char *p, *usr_qf_name, *grp_qf_name;
>>                           ^~~~~~~~~~~
>> fs/ext4/super.c:1977:12: error: unused variable 'usr_qf_name'
>> [-Werror=unused-variable]
>>   char *p, *usr_qf_name, *grp_qf_name;
>>
>> Fixes: 20cefcdc2040 ("ext4: fix use-after-free race in ext4_remount()'s
>> error path")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Hmm, I wonder if we should do something like:
>
> #define EXT4_UNUSED_VAR __attribute__ ((unused))
>
> and then we could do:
>
> 	char *p, *usr_qf_name EXT4_UNUSED_VAR, *grp_qf_name EXT4_UNUSED_VAR;
>
> More generally, I wonder if this is something we should have defined
> for the whole kernel, as opposed to a one-off hack that ACPI and ext4
> subsystems use.

I think the global __maybe_unused macro should work fine here.
I though about using that instead, but picked the #ifdef for
consistency with the other ifdef in the same function.

>  It's a little ugly, but I think it's much nicer than
> having extra #ifdefs such as:
>
> 	char *p;
> #ifdef CONFIG_QUOTA
> 	char *usr_qf_name, *grp_qf_name;
> #endif
>
> After all, the compiler is perfectly capable of ignoring variables
> which are unused.  And if it's only because of an #ifdef later in the
> function, it would be nice to not have an extra #ifdef in the variable
> declarations.

Another alternative that often results in more readable code is
to use a check like

        if (IS_ENABLED(CONFIG_QUOTA)) {
             ....
        }

around the conditional code instead of the #ifdef. This should usually
work unless the code accesses some struct members that are
also hidden in that #ifdef. I have not checked if that is the case here.

        Arnd
