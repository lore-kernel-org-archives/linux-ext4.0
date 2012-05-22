From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 1/1] ext4, dio: Remove overflow for size >2G in aio-dio
 code.
Date: Tue, 22 May 2012 11:11:04 -0500
Message-ID: <4FBBBA98.9090101@redhat.com>
References: <F9014F50-D1F6-4B64-8535-7452CC64B18A@qualexsystems.com> <1337500880.16053.YahooMailNeo@web192405.mail.sg3.yahoo.com> <CA+55aFwTN_uFXnoLo=uJnA21FeUs_92c8FvMY6-aXk=UmF1zgQ@mail.gmail.com> <1337570918.78986.YahooMailNeo@web192406.mail.sg3.yahoo.com> <CA+55aFxA0Do37AxoM2MPH5nnMa2VAPHp1pKJ7CiafGGQL-b0wQ@mail.gmail.com> <CA+55aFyGJTJh3jddXdapQiC4ou=sS9PFMcX_qVUGa5qBjUZjDg@mail.gmail.com> <20120521233133.GG12339@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	manish honap <manish_honap_vit@yahoo.co.in>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758613Ab2EVQLJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 May 2012 12:11:09 -0400
In-Reply-To: <20120521233133.GG12339@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/21/12 6:31 PM, Ted Ts'o wrote:
> On Mon, May 21, 2012 at 03:22:28PM -0700, Linus Torvalds wrote:
>>
>> So I'm pretty sure this patch is what we want, and rw_verify_area()
>> really is required to protect low-level filesystems from these kinds
>> of issues. Not just ext4.
>>
>> At the same time, I would *really* want somebody who actually uses
>> anything AIO to test it out too. Because I want to not only commit it,
>> but also mark it for stable - and it would be nice to have some more
>> testing than me saying "ok, it passes the one test-case sent to me"
>> and "hey, the code looks sane".

Just FWIW, the ext4_file_write() part of this fix was sent by Zheng Liu on 4/12/12:

[PATCH RESEND] ext4: change return value from int to ssize_t in ext4_file_write

I'll see about writing an xfstest for this stuff too so it doesn't regress again.

-Eric

> Hi Linus,
> 
> We do use AIO at Google, and I primarily use fio (usually as part of
> xfstests) to test AIO functionality.
> 
> If you like I can carry the patch in the ext4 tree and test it as part
> of the ext4 commits for the merge window.
> 
> I probably won't be able to get to it until a bit later in the week,
> though.  Things have been really crazy for me this past two months...
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

