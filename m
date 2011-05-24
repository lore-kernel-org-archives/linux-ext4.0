From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -v2] ext4: use truncate_setsize() unconditionally
Date: Tue, 24 May 2011 17:31:23 -0500
Message-ID: <4DDC31BB.6080406@redhat.com>
References: <BANLkTi=0NSws0GV4hP5KPPqvp4bxOSEbaQ@mail.gmail.com>	<1306178341-17632-1-git-send-email-tytso@mit.edu>	<4DDBC0EA.7000609@redhat.com> <BANLkTinAsaFUUEhren4pcyzBw=iyrs8r4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jiaying Zhang <jiayingz@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab1EXWb1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 May 2011 18:31:27 -0400
In-Reply-To: <BANLkTinAsaFUUEhren4pcyzBw=iyrs8r4w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/24/11 5:06 PM, Jiaying Zhang wrote:
> On Tue, May 24, 2011 at 7:30 AM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 5/23/11 2:19 PM, Theodore Ts'o wrote:
>>> In commit c8d46e41 (ext4: Add flag to files with blocks intentionally
>>> past EOF), if the EOFBLOCKS_FL flag is set, we call ext4_truncate()
>>> before calling vmtruncate().  This caused any allocated but unwritten
>>> blocks created by calling fallocate() with the FALLOC_FL_KEEP_SIZE
>>> flag to be dropped.  This was done to make to make sure that
>>> EOFBLOCKS_FL would not be cleared while still leaving blocks past
>>> i_size allocated.  This was not necessary, since ext4_truncate()
>>> guarantees that blocks past i_size will be dropped, even in the case
>>> where truncate() has increased i_size before calling ext4_truncate().
>>>
>>> So fix this by removing the EOFBLOCKS_FL special case treatment in
>>> ext4_setattr().  In addition, use truncate_setsize() followed by a
>>> call to ext4_truncate() instead of using vmtruncate().  This is more
>>> efficient since it skips the call to inode_newsize_ok(), which has
>>> been checked already by inode_change_ok().  This is also in a win in
>>> the case where EOFBLOCKS_FL is set since it avoids calling
>>> ext4_truncate() twice.
>>>
>>> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
>>> ---
>>>  Jiayingz pointed out that in the case where we fallocate 12k, write 4k, and
>>>  then truncate to 4k, we should discard the excess fallocate'd blocks.  So if
>>>  attr->ia_size == inode.i_size, we can skip the truncate_setsize() call, but
>>>  if the EOFBLOCKS_FL flag is set, we should still call ext4_truncate().
>>
>> are there xfstests which cover this explicitly?  It should be simple to write.
>>
> Vivek has written a xfstest to cover this and more fallocate/truncate cases:
> http://old.nabble.com/-PATCH--xfstests%3A-test-fallocate%2C-write%2C-ftruncate-combinations.-to31666685.html#a31666685

ah, right - ok, thanks!  Sorry for not keeping up.

-Eric

> Jiaying
> 
>> If filesystem behavior differs we can always make ext4-only tests.
>>
>> -Eric
>>

