From: David Lang <david@lang.hm>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Wed, 14 Aug 2013 23:18:01 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1308142316220.31947@nftneq.ynat.uz>
References: <520BB9EF.5020308@linux.intel.com>
	<20130814194359.GA22316@thunk.org> <520BED7A.4000903@intel.com>
	<20130814230648.GD22316@thunk.org>
	<CALCETrVaRQ3WQ5++Uu_0JTaVnjUugAaAhqQK__7r5YWvLxpAhw@mail.gmail.com>
	<20130815011101.GA3572@thunk.org> <20130815021028.GM6023@dastard>
	<CALCETrUfuzgG9U=+eSzCGvbCx-ZskWw+MhQ-qmEyWZK=XWNVmg@mail.gmail.com>
	<20130815060149.GP6023@dastard>
	<CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Andi Kleen <ak@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Dave Hansen <dave.hansen@intel.com>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <CALCETrUF+dGhE3qv4LoYmc7A=a+ry93u-d-GgHSAwHXvYN+VNw@mail.gmail.com>
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

On Wed, 14 Aug 2013, Andy Lutomirski wrote:

>> The big problem with this approach is that not doing the
>> timestamp update on page faults is going to break the inode change
>> version counting because for ext4, btrfs and XFS it takes a
>> transaction to bump that counter. NFS needs to know the moment a
>> file is changed in memory, not when it is written to disk. Also, NFS
>> requires the change to the counter to be persistent over server
>> failures, so it needs to be changed as part of a transaction....
>
> NFS can do whatever it wants, although I suspect that even NFS can get
> away with deferring cmtime updates.

NFS already has to do syncs to make sure the data is safe on disk, have a flag 
that NFS can use to make the ctime safe, everyone else can get the performance 
improvement and NFS can have it's slow-but-safe approach.

David Lang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
