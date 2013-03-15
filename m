From: Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH] xfstests: make defrag test 222 generic
Date: Fri, 15 Mar 2013 11:05:08 -0500
Message-ID: <514346B4.3040701@sandeen.net>
References: <513F5B0A.4030405@redhat.com>
	<20130315145540.GG7229@twin.jikos.cz> <51434653.40808@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>, dsterba@suse.cz,
	linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
To: Rich Johnston <rjohnston@sgi.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <51434653.40808@sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On 3/15/13 11:03 AM, Rich Johnston wrote:
> On 03/15/2013 09:55 AM, David Sterba wrote:
>> On Tue, Mar 12, 2013 at 11:42:50AM -0500, Eric Sandeen wrote:
>>> Define a new _defrag_dir() helper which just runs noisy/debug
>>> dir defrag for ext4 and/or btrfs as well, and use that in 222
>>> instead of hardcoded xfs_fsr.
>>
>> Dir defrag on btrfs does not recurse in the given directory to defrag
>> all files, but defragments the tree of the containing subvolume and the
>> whole extent tree (thus needs CAP_SYS_ADMIN).
>>
>> This is known (and not very intuitive) behaviour, it would be better to
>> add a special parameter to defrag the root and/or the extent root and
>> pass it down to the ioctl via flags.
>>
>> Until this is implemented I suggest to use a workaround via 'find':
>>
>>   find $dir -print -execdir $DEFRAG_PROG '{}' +
>>
>> Otherwise the test looks ok.
>>
>> david
> 
> Eric, I will make this change at commit time if you agree?
> 
> David, can I put your name as the reviewer when I do?

I think that's big enough change I should send a V2. and
make a btrfs-special case in _defrag_dir.

-Eric

> Thanks
> --Rich
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
