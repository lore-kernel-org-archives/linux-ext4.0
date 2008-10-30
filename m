From: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 patches for 2.6.26?
Date: Thu, 30 Oct 2008 19:20:26 -0400
Message-ID: <20081030232026.GA10779@mit.edu>
References: <6601abe90810301149g72f48f3y8bf3bda864337f92@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:59268 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754863AbYJ3XU3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Oct 2008 19:20:29 -0400
Content-Disposition: inline
In-Reply-To: <6601abe90810301149g72f48f3y8bf3bda864337f92@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 30, 2008 at 11:49:07AM -0700, Curt Wohlgemuth wrote:
> 
> I'm working on a kernel tree based on 2.6.26, with patches from
> 
>         http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.26-ext4-6/
> 
> applied as well.  I'm trying to update our tree to a more recent set
> of ext4 patches, and am having difficulty.
> 
> Is there a simple recipe for this?  Or am what I'm trying to do (use
> latest patches with an older kernel) just asking for trouble?  

In general, the answer is "just asking for trouble", but git does have
a way of making this easier.

Effectively, what you'll need to do is forward-port fs/ext4 and
fs/jbd2 so that you have the latest version into 2.6.26.  As it turns
out the latest ext4 patch queue (which has some bug fixes you'll want)
is based on 2.6.28-rc2, so you'll want to extract out all patches that
touch the fs/ext4 directory between 2.6.26 and 2.6.28-rc2.  I happen
to know that since 2.6.26 some of the changes in fs/ext4 depend on two
changes that we made to include/linux/percpu_counter.h (and I've
checked to make sure those were the only two changes we cared about
between 2.6.26 and 2.6.28-rc2).  So to generate the list of SHA1
hashes, we use git in a Linux 2.6 repository:

git rev-list --reverse v2.6.26..v2.6.28-rc2 -- fs/ext4 fs/jbd2 include/linux/percpu_counter.h Documentation/filesystems/ext4.txt > /tmp/revs

We can then create a Unix mbox of all of these patches:

git show --pretty=email `cat /tmp/revs` > /tmp/ext4-patches

I then reviewed this list using my favoriate mailreader (which happens
to be mutt, but you can use any mail reader that understands Unix
mbox), and found a few patches that will probably depend on other
changes that were made since 2.6.26:

51cc50685a4275c6a02653670af9f108a64e01cf
e6305c43eda10ebfd2ad9e35d6e172ccc7bb3695
77e69dac3cefacee939cb107ae9cd520a62338e0
8f616cd5249e03c9e1b371623d85e76d4b86bbc1
529ae9aaa08378cfe2a4350bded76f32cc8ff0ce
4f3e7524b2e703d9f8b02ac338153a53dd7ede66
3295f0ef9ff048a4619ede597ad9ec9cab725654
23a0ee908cbfba3264d19729c67c22b20fa73886
6da0b38f4433fb0f24615449d7966471b6e5eae0
9a1c3542768b5a58e45a9216921cd10a3bae1205
8264613def2e5c4f12bc3167713090fd172e6055
440037287c5ebb07033ab927ca16bb68c291d309
22484856402bfa1ff3defe47f6029ab0418240d9

If you were to then remove these SHA1 hashes from the /tmp/revs list,
and then re-run the "git show --pretty=email..." command, I *think*
that if you take that resulting set of patches, it *should* apply to
2.6.26, and that it *should* compile and result in a valid kernel.  I
haven't tried it myself, though.

I would then take the patches from the ext4 patch queue to get some
latest patches that you'll probably need.

Hope this helps,

						- Ted
