From: Matija Nalis <mnalis-ml@voyager.hr>
Subject: Re: optimising filesystem for many small files
Date: Sun, 18 Oct 2009 13:41:00 +0200
Message-ID: <20091018114100.GA26721@eagle102.home.lan>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
	<4AD9D599.3000306@redhat.com>
	<84c89ac10910171056i773dfb93wc2e917a086dd8ef0@mail.gmail.com>
	<20091017222619.GA10074@mit.edu>
	<84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, ext3-users@redhat.com
To: Viji V Nair <viji@fedoraproject.org>
Return-path: <ext3-users-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <84c89ac10910180231p202fb5f1r2e192e9ac0b51509@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Sun, Oct 18, 2009 at 03:01:46PM +0530, Viji V Nair wrote:
> The application which we are using are modified versions of mapnik and
> tilecache, these are single threaded so we are running 4 process at a

How does it scale if you reduce the number or processes - especially if you
run just one of those ? As this is just a single disk, 4 simultaneous
readers/writers would probably *totally* kill it with seeks.

I suspect it might even run faster with just 1 process then with 4 of
them...

> time. We can say only four images are created at a single point of
> time. Some times a single image is taking around 20 sec to create. I

is that 20 secs just the write time for an precomputed file of 10k ? 
Or does it also include reading and processing and writing ?

> can see lots of system resources are free, memory, processors etc
> (these are 4G, 2 x 5420 XEON)

I do not see how the "lots of memory" could be free, especially with such a
large number of inodes. dentry and inode cache alone should consume those
pretty fast as the number of files grow, not to mention (dirty and
otherwise) buffers...

You may want to tune following sysctls to allow more stuff to remain in
write-back cache (but then again, you will probably need more memory):

vm.vfs_cache_pressure
vm.dirty_writeback_centisecs
vm.dirty_expire_centisecs
vm.dirty_background_ratio
vm.dirty_ratio


> The file system is crated with "-i 1024 -b 1024" for larger inode
> number, 50% of the total images are less than 10KB. I have disabled
> access time and given a large value to the commit also. Do you have
> any other recommendation of the file system creation?

for ext3, larger journal on external journal device (if that is an option)
should probably help, as it would reduce some of the seeks which are most
probably slowing this down immensely.


If you can modify hardware setup, RAID10 (better with many smaller disks
than with fewer bigger ones) should help *very* much. Flash-disk-thingies of
appropriate size are even better option (as the seek issues are few orders
of magnitude smaller problem). Also probably more RAM (unless you full
dataset is much smaller than 2 GB, which I doubt). 

On the other hand, have you tried testing some other filesystems ? 
I've had much better performance with lots of small files of XFS (but that
was on big RAID5, so YMMV), for example.

-- 
Opinions above are GNU-copylefted.
