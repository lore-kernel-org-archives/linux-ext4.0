From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: File System Selection
Date: Tue, 05 May 2009 10:23:22 -0500
Message-ID: <4A0059EA.4090904@redhat.com>
References: <1240983206.446412847@192.168.1.35>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ext3-users@redhat.com
To: Ramesh <ramesh@arasan.com>
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <1240983206.446412847@192.168.1.35>
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

Ramesh wrote:
> Hi All,
> 
> 
> I am developing a SD Block Driver.
> 
> As per old specification (SD Spec 2.0 ) Maximum size of SD memory
> card is 32 GB. - We used ext2 file system.
> 
> By referring the new Specification (SD Spec 3.0) SD memory card size
> is reached upto and including 2TB (Terra Byte) - Block size strictly
> limited to 512 only (as per specification).
> 
> My Questions.
> 
> 1. For 2TB disk with Block size 512, Which file system is preferred
> (ext3/ext4)

do you mean sector size of the block device, or block size of the
fileystem?  I guess it doesn't matter much either way, 2^32*512 is 2T.
Either ext3 or ext4 can handle this size, you'll probably need to make
your decision based on other factors.

> 2. In a 32 bit machine, If I installed the Fedora 10 ( having ext4),
> am I able to use it as effectively ( for the maximum disk/file size
> usage). To utilize 2TB or more size hard disk, is this allowable to
> use 32 bit machine with Ext4 fs?
> 

On a 32 bit machine you will be limited to 16T, this is actually a page
cache limitation.  But 2T should be fine.

-Eric


> Thanks in advance.
> 
> Regards, Ramesh
> 
