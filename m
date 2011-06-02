From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 1/2] ext4: arrange ext4_*_bit() macros
Date: Thu, 2 Jun 2011 10:25:28 +0900
Message-ID: <BANLkTinbiK0ESg90EU9d8WvL_VjbQpthhQ@mail.gmail.com>
References: <1306939009-11283-1-git-send-email-akinobu.mita@gmail.com>
	<46950A08-9300-4649-A38D-88829035DFC2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63934 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab1FBBZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Jun 2011 21:25:29 -0400
In-Reply-To: <46950A08-9300-4649-A38D-88829035DFC2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/6/2 Andreas Dilger <adilger.kernel@dilger.ca>:
> On 2011-06-01, at 8:36 AM, Akinobu Mita wrote:
>> - remove unused ext4_{set,clear}_bit_atomic and ext4_find_first_zero=
_bit
>> - rename ext4_{set,clear}_bit to ext4_test_and_{set,clear}_bit
>> - reintroduce ext4_{set,clear}_bit for __{set,clear}_bit_le
>>
>> This changes ext4_{set,clear}_bit safely, because if someone uses
>> these macros without noticing the change, new ext4_{set,clear}_bit
>> don't have return value and causes compiler errors where the return
>> value is used.
>
> I don't think it makes sense to change all of the ext4_set_bit() call=
s that
> don't check the return code to use ext4_test_and_set_bit(), just to r=
eturn
> them back to ext4_set_bit() in the next patch.
>
> If you want to do this in separate steps, and maintain git bisect wor=
king,
> then it would be more clear to have two patches:
>
> Patch #1: Add new ext4_test_and_set_bit() macro
> #define ext4_test_and_set_bit =A0 =A0 =A0 =A0 =A0 __test_and_set_bit_=
le
> {change ext4_set_bit() calls that check return to =A0ext4_test_and_se=
t_bit()}
>
> Patch #2: Change ext4_set_bit() to not return old bit
> #define ext4_set_bit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__set_bit=
_le
> {nothing else changes}
>
> Alternately, you could just leave the calls that do not check the ret=
urn
> value as ext4_set_bit() and have only a single patch.

OK, I will do in a single patch. The change will be much smaller than t=
his
version because there are only two calls where ext4_{set,clear}_bit() c=
hecks
the return value.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
