From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: optimising filesystem for many small files
Date: Sat, 17 Oct 2009 09:32:57 -0500
Message-ID: <4AD9D599.3000306@redhat.com>
References: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ext3-users@redhat.com
To: Viji V Nair <viji@fedoraproject.org>
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <84c89ac10910162352x5cdeca37icfbf0af2f2325d7c@mail.gmail.com>
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

Viji V Nair wrote:
> Hi,
> 
> System : Fedora 11 x86_64
> Current Filesystem: 150G ext4 (formatted with "-T small" option)
> Number of files: 50 Million, 1 to 30K png images
> 
> We are generating these files using a python programme and getting very 
> slow IO performance. While generation there in only write, no read. 
> After generation there is heavy read and no write.
> 
> I am looking for best practices/recommendation to get a better performance.
> 
> Any suggestions of the above are greatly appreciated.
> 
> Viji
> 

I would start with using blktrace and/or seekwatcher to see what your IO 
patterns look like when you're populating the disk; I would guess that 
you're seeing IO scattered all over.

How you are placing the files in subdirectories will affect this quite a 
lot; sitting in 1 directory for a while, filling with images, before 
moving on to the next directory, will probably help.  Putting each new 
file in a new subdirectory will probably give very bad results.

-Eric
