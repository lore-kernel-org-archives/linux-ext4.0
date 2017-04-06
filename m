From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] fstests: generic: Check if cycle mount and sleep can
 affect fiemap result
Date: Thu, 6 Apr 2017 11:28:01 -0500
Message-ID: <36663e81-9520-0c52-5e72-1d54ddbfb0b7@sandeen.net>
References: <20170403070923.18518-1-quwenruo@cn.fujitsu.com>
 <20170405023526.GS22845@eguan.usersys.redhat.com>
 <20170406162616.zsnbgx6vy2fgugmq@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Eryu Guan <eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170406162616.zsnbgx6vy2fgugmq@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 4/6/17 11:26 AM, Theodore Ts'o wrote:
> On Wed, Apr 05, 2017 at 10:35:26AM +0800, Eryu Guan wrote:
>>
>> Test fails with ext3/2 when driving with ext4 driver, fiemap changed
>> after umount/mount cycle, then changed back to original result after
>> sleeping some time. An ext4 bug? (cc'ed linux-ext4 list.)
> 
> I haven't had time to look at this, but I'm not sure this test is a
> reasonable one on the face of it.
> 
> A file system may choose to optimize a file's extent tree for whatever
> reason it wants, whenever it wants, including on an unmount --- and
> that would not be an invalid thing to do.  So to have an xfstests that
> causes a test failure if a file system were to, say, do some cleanup
> at mount or unmount time, or when the file is next opened, to merge
> adjacent extents together (and hence change what is returned by
> FIEMAP) might be strange, or even weird --- but is this any of user
> space's business?  Or anything we want to enforce as wrong wrong wrong
> by xfstests?

I had the same question.  If the exact behavior isn't defined anywhere,
I don't know what we can be testing, TBH.

-Eric

> 		       		   	   - Ted
