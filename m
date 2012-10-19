From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [RFC v3 11/13] vfs: add 3 new ioctl interfaces
Date: Fri, 19 Oct 2012 16:21:54 +0800
Message-ID: <CAEH94LjWqh3q29AnQpmedLjjxY66WxcNueiprXkzGkceBxHPkQ@mail.gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
	<1349863655-29320-12-git-send-email-zwu.kernel@gmail.com>
	<20121016031710.GD2864@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxram@linux.vnet.ibm.com, viro@zeniv.linux.org.uk,
	dave@jikos.cz, tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121016031710.GD2864@dastard>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Oct 16, 2012 at 11:17 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Oct 10, 2012 at 06:07:33PM +0800, zwu.kernel@gmail.com wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>>   FS_IOC_GET_HEAT_INFO: return a struct containing the various
>> metrics collected in btrfs_freq_data structs, and also return a
>
> I think you mean hot_freq_data :P
>
>> calculated data temperature based on those metrics. Optionally, retrieve
>> the temperature from the hot data hash list instead of recalculating it.
>
> To get the heat info for a specific file you have to know what file
> you want to get that info for, right?  I can see the usefulness of
> asking for the heat data on a specific file, but how do you find the
> hot files in the first place? i.e. the big question the user
> interface needs to answer is "what files are hot?".
>
> Once userspace knows what the hottest files are, it can open them
> and query the data via the above ioctl, but expecting userspace to
> iterate millions of inodes in a filesystem to find hot files is very
> inefficient.
>
> FWIW, if you were to return file handles to the hottest files, then
Good idea. I am not very clear about how to implement it. file handles
mean file_handle??  How to return them to the application? via
debugfs? How many hottest files should be returned?? Top 100?

> the application could open and query them without even needing to
> know the path name to them. This woul dbe exceedingly useful for
> defragmentation programs, especially as that is the way xfs_fsr
> already operates on candidate files.(*)
>
> IOWs, sometimes the pathname is irrelevant to the operations that
> applications want to perform - all they care about having an
> efficient method of finding the inode they want and getting a file
> descriptor that points to the file. Given the heat map info fits
> right in to the sort of operations defrag and data mover tools
> already do, it kind of makes sense to optimise the interface towards
> those uses....
>
> (*) i.e. finds them via bulkstat which returns handle information
> along with all the other inode data, then opens the file by handle
> to do the defrag work....
>
>>   FS_IOC_GET_HEAT_OPTS: return an integer representing the current
>> state of hot data tracking and migration:
>>
>> 0 = do nothing
>> 1 = track frequency of access
>>
>>   FS_IOC_SET_HEAT_OPTS: change the state of hot data tracking and
>> migration, as described above.
>
> I can't see how this is a manageable interface. It is not
> persistent, so after every filesystem mount you'd have to set the
> flag on all your inodes again. Hence, for the moment, I'd suggest
> that dropping per-inode tracking control until all the core issues
> are sorted out....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,

Zhi Yong Wu
