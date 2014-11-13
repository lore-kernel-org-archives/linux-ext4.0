From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: xfstest generic/018 and ext4 defrag
Date: Thu, 13 Nov 2014 15:36:13 -0600
Message-ID: <5465244D.2090708@redhat.com>
References: <CAH2r5mvAGe-N0e2rOsEe4DBT1tRM0Uv8rNQChmQY+d7dkLxR2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Steve French <smfrench@gmail.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934093AbaKMVgQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 16:36:16 -0500
In-Reply-To: <CAH2r5mvAGe-N0e2rOsEe4DBT1tRM0Uv8rNQChmQY+d7dkLxR2w@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/13/14 3:16 PM, Steve French wrote:
> I see an earlier thread about ext4 defrag problems causing this
> failure on xfstest generic/018 running on ext4
> 
> generic/018 1s ... [failed, exit status 1] - output mismatch (see
> /home/sfrench/xfstests/results//generic/018.out.bad)
>     --- tests/generic/018.out 2014-11-13 11:20:05.385406288 -0800
>     +++ /home/sfrench/xfstests/results//generic/018.out.bad 2014-11-13
> 12:33:19.317806287 -0800
>     @@ -10,10 +10,5 @@
>      After: 1
>      Write backwards sync, but contiguous - should defrag to 1 extent
>      Before: 10
>     -After: 1
>     -Write backwards sync leaving holes - defrag should do nothing
>     -Before: 16
>     -After: 16
>     ...
> 
> but wasn't clear whether it was fixed upstream.  It failed on two out
> of three runs for me on most current ext4.  My test is on most current
> Ubuntu x86_64  (and with 3.18-rc3 kernel)
> I couldn't find version info for e4defrag from the command line but
> other ext4 tools are reasonably recent it seems as Ubuntu packages
> them e.g. EXT2FS Library version 1.42.10, 18-May-2014
> 
> Is generic xfstest 18 still broken on ext4?

Did you try upstream?

When I test upstream, it passes.  Because:

# git log --oneline v1.42.10.. misc/e4defrag.c 
c7c539e e4defrag: backwards-allocated files should be defragmented too
47fee2e e2fsprogs: introduce ext2fs_close_free() helper

So no, it is not still broken.

> Also am curious about test generic/026
> 
> generic/026  [not run] ext4 does not define maximum ACL count
> 
> Is that expected?

in common/attr:

# filesystems that want to test maximum supported acl counts need to
# add support in here
_acl_get_max()
...

Because ext4 has not added support there, yes, it is expected that it
will not run.  ;)

I don't honestly know if ext4 has an upper limit on acls.

-Eric

