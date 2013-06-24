From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Date: Sun, 23 Jun 2013 20:32:32 -0400 (EDT)
Message-ID: <7D1878F6-0387-48F3-8724-4A8946AECF9E@redhat.com>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com> <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Namjae Jeon <linkinjeon@gmail.com>,
	"tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"a.sangwan@samsung.com" <a.sangwan@samsung.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <03D226D6-9598-473F-90FC-03A389E2A625@dilger.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 23, 2013, at 12:01 PM, Andreas Dilger <adilger@dilger.ca> wrote:

> On 2013-06-23, at 0:07, Namjae Jeon <linkinjeon@gmail.com> wrote:
> 
>> From: Namjae Jeon <namjae.jeon@samsung.com>
>> 
>> This patch series introduces 2 new ioctls for ext4.
>> 
>> Truncate_block_range ioctl truncates blocks from source file.
> 
> How is this different from fallocate(FALLOC_FL_PUNCH_HOLE)?  That is already in existing kernels, and portable across multiple filesystems. 
> 
Same question.  Punch hole should do this already...


>> Transfer_block_range ioctl transfers data blocks from source file
>> and append them at the end of destination file.
> 
> There is already a similar ioctl for defragmenting files. Is it possible to use that, or does it have different semantics?
> 
>> Ioctl1:        EXT4_IOC_TRUNCATE_BLOCK_RANGE:
>> This ioctl truncates a range of data blocks from file.
>> It is useful to remove easily and quickly the garbage data
>> at the middle of file.
>> 
>> e.g. we have a movie file and there is long advertisement in movie file.
>> user want to remove only advertisement range.
> 
> While this works in theory, there is very little chance that the movie data will align exactly to filesystem block boundaries. 
> 
Or more importantly on compression codec boundaries.   Wouldn't this look like corruption at playback time?

Eric

> Cheers, Andreas 
> 
>> 1) Movie file (8GB), There is the adverisement of 500MB size.
>> ____________________________________________________________________
>> |                     |                   |                         |
>> |   a) range          | b) Advertisement  |     c) range            | 
>> |                     | (unneeded data)   |                         |
>> |_____________________|___________________|_________________________| 
>> 
>> 2) Currently if user want to remove portion b), the conventional way
>>   would be to copy a) and c) (7.5GB) to new file by reading data from
>>   original file and writing to new file, followed up by  delete original
>>   file and rename new file. It will take long time.
>>   When we measure time, it takes around 3 minutes.
>> 
>> 3) If we use EXT4_IOC_TRUNCATE_BLOCK_RANGE, we can have garbage data removed
>>   in less than a second. Also, no need to perform deletion and rename.
>> _______________________________________________
>> |                     |                        |
>> |   a) range          |     c) range           | 
>> |                     |                        |
>> |_____________________|________________________| 
>> 
>> 
>> #define EXT4_IOC_TRUNCATE_BLOCK_RANGE  _IOW('f', 18, struct truncate_range)
>> struct truncate_range {
>>      __u32 start_block;
>>      __u32 length;
>> };
>> 
>> example =>
>> Originally the file "abc" has the below extent tree:
>> debugfs:  ex abc
>> Level Entries       Logical        Physical Length Flags
>> 0/ 0   1/  3     0 -     4  33615 -  33619      5 
>> 0/ 0   2/  3     5 -     9  33855 -  33859      5 
>> 0/ 0   3/  3    10 -    14  69657 -  69661      5
>> 
>> ls -lh abc
>> -rw-r--r--    1 root     0          60.0K Jan  1 00:01 abc
>> 
>> du -h abc
>> 60.0K    abc
>> 
>> e4_truncate_block_range abc 2 10
>> Return:
>> : Success
>> 
>> After executing truncate_block_range ioctl, the extent tree:
>> ex abc
>> Level Entries       Logical        Physical Length Flags
>> 0/ 0   1/  2     0 -     1  33615 -  33616      2 
>> 0/ 0   2/  2     2 -     4  69659 -  69661      3 
>> 
>> ls -lh abc
>> -rw-r--r--    1 root     0          20.0K Jan  1 00:08 abc
>> 
>> du -h abc
>> 20.0K    abc
>> 
>> This ioctl works in 2 parts:
>> 1) remove _only_ data blocks that resides within specified range.
>> If the entire range is a hole than nothing is removed.
>> 
>> 2) update file's logical block offsets ranging from block number
>> "start_block + length" to last logical block of file such that
>> lblk_number = lblk_number - length;
>> This is done by updating starting block of all the extents that
>> resides within the range.
>> 
>> If "start_block + length" is already equal to the last block of file
>> than no block is updated. This case is similar to convential truncate.
>> 
>> In the above example:
>> The data blocks ranging from [2 - 11] have been removed
>> and the logical offsets of the file beyond block number 12 till last block 
>> of file are updated by subtracting length from each of logical numbers.
>> This gives a contiguous logical space to the file.
>> Also, the logical size and disksize of the file are updated accordingly.
>> 
>> Ioctl2:        EXT4_IOC_TRANSFER_BLOCK_RANGE:
>> This ioctl transfers a range of data blocks from source file and append
>> them at the end of the destination file.
>> This is not actual data transfer but only metadata is moved.
>> 
>> ____________________________________________________________________
>> |                     |                   |                         |
>> |   a) range          | b) range          |     c) range            |
>> |                     |                   |                         |
>> |_____________________|___________________|_________________________|
>> 
>> If user does not want b) in the orig file but wants to make a new file
>> comprising only b) OR wants b) at the end of an already existing file,
>> the conventional way of doing it would be to:
>> 1) Copy b) to new file
>> 2) Copy c) to temp file
>> 3) Truncate orig file to a)
>> 4) Copy c) from temp file to the end of orig file.
>> 5) Delete temp file.
>> 
>> After this operations =>
>> orig_file:
>> __________________________________________
>> |                     |                   |
>> |   a) range          | c) range          |
>> |                     |                   |
>> |_____________________|___________________|
>> 
>> new_file:
>> _______________________
>> |                     |
>> |   b) range          |
>> |                     |
>> |_____________________|
>> 
>> Again, this operation would take a long time (depending on the sizes of range)
>> if done using conventional way while using transfer_block_range ioctl reduces
>> the time within a second.
>> 
>> #define EXT4_IOC_TRANSFER_BLOCK_RANGE  _IOW('f', 19, struct transfer_range)
>> struct transfer_range {
>>   __u32 dest_fd;
>>   __u32 start_block;
>>   __u32 length;
>> };
>> 
>> example=>
>> debugfs: ex source
>> Level Entries       Logical        Physical Length Flags
>> 0/ 1   1/  1     0 -    24  32809              25
>> 1/ 1   1/  5     0 -     4   4071 -   4075      5 
>> 1/ 1   2/  5     5 -     9   4081 -   4085      5 
>> 1/ 1   3/  5    10 -    14   4091 -   4095      5 
>> 1/ 1   4/  5    15 -    19   4101 -   4105      5 
>> 1/ 1   5/  5    20 -    24   4151 -   4155      5 
>> 
>> debugfs:  ex dest
>> Level Entries       Logical        Physical Length Flags
>> 0/ 0   1/  3     0 -     4  32825 -  32829      5 
>> 0/ 0   2/  3     5 -     9  33545 -  33549      5 
>> 0/ 0   3/  3    10 -    14  33615 -  33619      5
>> 
>> ls -lh source 
>> -rw-r--r--    1 root     0         100.0K Jan  1 00:01 source
>> ls -lh dest 
>> -rw-r--r--    1 root     0          60.0K Jan  1 00:01 dest
>> 
>> du -h source 
>> 104.0K    source
>> du -h dest 
>> 60.0K    dest
>> 
>> e4_transfer_block_range source dest 2 10
>> Return:
>> : Success
>> 
>> debugfs:  ex source
>> Level Entries       Logical        Physical Length Flags
>> 0/ 1   1/  1     0 -    24  32809              25
>> 1/ 1   1/  4     0 -     1   4071 -   4072      2 
>> 1/ 1   2/  4    12 -    14   4093 -   4095      3 
>> 1/ 1   3/  4    15 -    19   4101 -   4105      5 
>> 1/ 1   4/  4    20 -    24   4151 -   4155      5 
>> debugfs:  ex dest
>> Level Entries       Logical        Physical Length Flags
>> 0/ 1   1/  1     0 -    24  32835              25
>> 1/ 1   1/  6     0 -     4  32825 -  32829      5 
>> 1/ 1   2/  6     5 -     9  33545 -  33549      5 
>> 1/ 1   3/  6    10 -    14  33615 -  33619      5 
>> 1/ 1   4/  6    15 -    17   4073 -   4075      3 
>> 1/ 1   5/  6    18 -    22   4081 -   4085      5 
>> 1/ 1   6/  6    23 -    24   4091 -   4092      2 
>> 
>> ls -lh source
>> -rw-r--r--    1 root     0         100.0K Jan  1 00:04 source
>> ls -lh dest 
>> -rw-r--r--    1 root     0         100.0K Jan  1 00:04 dest
>> 
>> du -h source 
>> 64.0K    source
>> du -h dest
>> 104.0K    dest
>> 
>> The data blocks lying between [start_block to start_block + length) are appended
>> contiguously at the end of destination file.
>> The block transfer leaves a hole in the source file.
>> If any hole is encountered in the range, it is ommited.
>> 
>> This ioctl does not change the logical size of the source file hence
>> leaves a hole in place of transfered range.
>> If user want contiguous logical space for source file,
>> it can truncate the hole by calling truncate_range_ioctl for source file.
>> 
>> Example for above "source" file:
>> e4_truncate_block_range source 2 10
>> Return:
>> : Success
>> debugfs:  ex source
>> Level Entries       Logical        Physical Length Flags
>> 0/ 1   1/  1     0 -    14  32809              15
>> 1/ 1   1/  4     0 -     1   4071 -   4072      2 
>> 1/ 1   2/  4     2 -     4   4093 -   4095      3 
>> 1/ 1   3/  4     5 -     9   4101 -   4105      5 
>> 1/ 1   4/  4    10 -    14   4151 -   4155      5 
>> 
>> Namjae Jeon (3):
>> ext4: Add EXT4_IOC_TRUNCATE_BLOCK_RANGE ioctl
>> ext4: make mext_next_extent non static and move get_ext_path
>> ext4: Add EXT4_IOC_TRANSFER_BLOCK_RANGE ioctl
>> 
>> -- 
>> 1.7.9.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
