From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: fsck.ext4 taking a very long time because of "should not have EOFBLOCKS_FL set"
Date: Thu, 20 Oct 2011 12:59:58 -0600
Message-ID: <7DD24CD6-FB72-4502-AA8D-E3C37289DFFE@dilger.ca>
References: <CAFj9jjyLbPjehM1QbVAK9qRQ3F45sRpp055cKGa6EijWi1CBUw@mail.gmail.com> <20111019185344.GA4284@thunk.org> <CAFj9jjwOuukgzsgA8i3qzvEi3N7E19ugZfh3d+KGgGrrAms2OA@mail.gmail.com> <CAFj9jjzE_hW9sx3qAWrF+L9rufLL9rVZe_17Tqnk0WLgEiw_=Q@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Johannes Segitz <johannes.segitz@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:32394 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1JTS77 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2011 14:59:59 -0400
In-Reply-To: <CAFj9jjzE_hW9sx3qAWrF+L9rufLL9rVZe_17Tqnk0WLgEiw_=Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-10-20, at 4:58 AM, Johannes Segitz wrote:
> On Wed, Oct 19, 2011 at 20:53, Ted Ts'o <tytso@mit.edu> wrote:
>>    Leaving EOFBLOCKS_FL set when it should not be isn't a huge deal, and
>>    is certainly than having high availability timeout alerts going off
>>    left and right.  So in this case, the best fix might be to put the
>>    following in /etc/e2fsck.conf:
>> 
>>    [problems]
>>    0x010060 = {                        # PR_1_EOFBLOCKS_FL_SET
>>         force_no = true
>>         no_ok = true
>>         no_nomsg = true
>>    }
> 
> That was pretty much what i was looking for, thank you. I'll kill fsck
> tonight if it's still running and run it again with those settings.

At least it should have fixed the inodes that it has already scanned
on disk, so the next time you get a chance to run it without the above
[problems] option, it should be able to continue from where it left off.

Cheers, Andreas





