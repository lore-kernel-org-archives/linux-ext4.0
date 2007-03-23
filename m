From: Ric Wheeler <ric@emc.com>
Subject: Re: Ext3 behavior on power failure
Date: Fri, 23 Mar 2007 06:47:26 -0400
Message-ID: <4603B03E.7080302@emc.com>
References: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: csar@stanford.edu, linux-ext4@vger.kernel.org,
	ext3-users@redhat.com
To: armangau_philippe@emc.com
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <A74E8B4A356D8143B79BBEB839421F3004023496@CORPUSMX20B.corp.emc.com>
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


armangau_philippe@emc.com wrote:
> Hi all,
>
> We are building a new system which is going to use ext3 FS. We would like to know more about the behavior of ext3 in the case of failure.  But before I procede, I would like to share more information about our future system. 
>
> *	Our application always does an fsync on files
> *	When symbolic links (more specifically fast symlink) are created, the host directory is also fsync'ed. 
> *	Our application is also going to front an EMC disk array configured using RAID5 or RAID6.
> *	We will be using multipathing  so that we can assume that no disk errors will be reported. 
>
> In this context , we would like to know the following for recovery after a power outage:
>
> 1.	When will an fsck have to be run (not counting  the scheduled fsck every N-mounts)?
> 2.	In the case of a crash, are the fsync-ed file contents and symbolic links safe no matter what?
>
> Thanks,

This is an interesting twist on some of the discussion that we have had 
at the recent workshop and in other forums on hardening  file system in 
order to prevent the need to fsck.

The twist is that we have a disk that will not lose power without being 
able to write to platter all of the data that has been sent - this is 
the case for most mid-range or higher disk arrays.

If the application can precisely use fsync() on files, directories and 
symlinks, it wants to know that all objects are safe on disk that have 
completed a successful fsync. It also wants to know that the file system 
will not need any recovery beyond replaying transactions after a power 
outage/reboot - simply mount, let the transactions get replayed and you 
should be good to go without the fsck.

The hard part of the question is to understand when and how often we 
will fail to deliver this easy case. Also, does any of the hardening in 
ext4 help here.

Maybe the Stanford explode work/analysis sheds some light on this behavior?

ric
