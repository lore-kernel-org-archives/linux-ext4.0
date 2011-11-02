From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: let ext4_ext_convet_to_initialized initialize var(eh)
 before using it
Date: Wed, 02 Nov 2011 10:04:13 -0500
Message-ID: <4EB15BED.10901@redhat.com>
References: <1320110481-12080-1-git-send-email-xiaoqiangnk@gmail.com> <20111101225222.GH32161@thunk.org> <CAMUAhYSh4VUbh3oG9hwi0FxMs=gMDiOHqvRhDgZTmP-_8PuW3g@mail.gmail.com> <CAMUAhYQPPt6Bke6zE=r3XAa6ukHUrxQe-R_oqBLOUM22j65WDQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>, Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Eric Gouriou <egouriou@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab1KBPET (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Nov 2011 11:04:19 -0400
In-Reply-To: <CAMUAhYQPPt6Bke6zE=r3XAa6ukHUrxQe-R_oqBLOUM22j65WDQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/2/11 3:22 AM, Eric Gouriou wrote:
> [Resend of my earlier message with HTML gunk removed and one edit. ]
> 
> On Tue, Nov 1, 2011 at 15:52, Ted Ts'o <tytso@mit.edu> wrote:
>>
>> On Tue, Nov 01, 2011 at 09:21:21AM +0800, Yongqiang Yang wrote:
>>> ext4_ext_convert_to_initialized() does not initialize eh before using it
>>> and this is introduced in commit 864d21652.
>>>
>>> Cc:Eric Gouriou <egouriou@google.com>
>>> Cc:"Theodore Ts'o" <tytso@mit.edu>
>>> Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
>>
>>>               eof_block = map->m_lblk + map->m_len;
>>>
>>>       depth = ext_depth(inode);
>>> +     eh = path[depth].p_hdr;
>>>       ex = path[depth].p_ext;
>>>       ee_block = le32_to_cpu(ex->ee_block);
>>>       ee_len = ext4_ext_get_actual_len(ex);
>>
>> Hmmm, nice catch.
>>
>> Looks like Eric dropped this line when he forward ported this patch to
>> v3.1.
> 
> Indeed I screwed up. Apologies for the trouble. I tested the patch thoroughly
> on our kernel version, ported it to ~ 2.6.39 and tested. This was a few months
> ago and could not find the time to complete the work then. When I got a chance
> to resume the effort, the upstream kernel had changed but I was not supposed
> to even build it due to security concerns with the kernel.org sources.
> So I redid
> the port blind, verified [the file] built but did not test.
> 
>>  Interestingly, I did test this using xfstests, and it didn't
>> complain.  Which probably means we don't have a good test coverage
>> that triggers the specific preconditions of this optimization.  Oops.
>> I'll fix this up now.
>>
>> Eric, when you have a chance, could you work up an xfstests test that
>> automates the various tests that you ran manually when you developed
>> this patch?  Thanks!!
> 
> Sure, but the "chance" may not manifest itself soon.

Which probably means "never" :(

This is definitely a "do as I say not as I (always) do" but in general:
having testcases used for testing commits, and not putting them into
the existing regression suite, is bad development practice.  It should
be a priority for all of us.

I know sometimes it is difficult or impossible (my latest xattr race testcase
requires (for now) a bunch of libraries from Ceph, and I haven't found a way
around that yet) but "I don't have time" is a poor excuse.

How did you do the tests?  I'd be glad to give you a hand with the formalized
testcase if you need it.

Thanks,

-Eric (Sandeen)

>  Eric
> 
>>
>>                                                - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

