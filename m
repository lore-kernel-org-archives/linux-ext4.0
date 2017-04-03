From: Joseph Richey <joerichey94@gmail.com>
Subject: Re: [PATCH] misc: fixed error handling in e4crypt
Date: Mon, 3 Apr 2017 09:52:38 -0700
Message-ID: <CAAXkRof5YiRg-NP6_=XTS8TvsTkHb7p4+SXeDbp_jVNhUy_QTg@mail.gmail.com>
References: <1490042076-25845-1-git-send-email-joerichey94@gmail.com> <20170401162419.sl4keqsb53zll6wf@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-ext4@vger.kernel.org, Michael Halcrow <mhalcrow@google.com>,
        Joe Richey <joerichey@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:33610 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbdDCQwk (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Apr 2017 12:52:40 -0400
Received: by mail-qk0-f178.google.com with SMTP id h67so20895301qke.0
        for <linux-ext4@vger.kernel.org>; Mon, 03 Apr 2017 09:52:39 -0700 (PDT)
In-Reply-To: <20170401162419.sl4keqsb53zll6wf@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thanks for catching this! KEYCTL_GET_KEYRING_ID returns -1 on error, so
e4crypt should definitely exit here. Sending the revised path.

Joe

On Sat, Apr 1, 2017 at 9:24 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Mar 20, 2017 at 08:34:36PM +0000, Joe Richey wrote:
>> +     if (keyring_id == KEY_SPEC_SESSION_KEYRING) {
>> +             keyring_id = keyctl(KEYCTL_GET_KEYRING_ID, keyring_id, 0);
>> +             if (keyring_id < 0)
>> +                     printf("Could not get session keyring.\n");
>> +     }
>>       rc = add_key(EXT2FS_KEY_TYPE_LOGON, key_ref_full, (void *)&key,
>>                    sizeof(key), keyring_id);
>
> Are you sure this is right?  If keyring_id is negative, we'll print
> the warning/error message --- and then pass the negative keyring_id to
> add_key.  Is that going to do the right thing?
>
>                                         - Ted
