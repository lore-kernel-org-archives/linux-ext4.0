From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 0/3] ext4: introduce two new ioctls
Date: Sun, 23 Jun 2013 15:22:14 +0900
Message-ID: <CAKYAXd84nNA+HbB3hEWYxO6joZ3Tbe=D2Pe8Ps6AJ_vxwOje7g@mail.gmail.com>
References: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b15ae1325dc9b04dfcc51eb
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, a.sangwan@samsung.com,
	Namjae Jeon <linkinjeon@gmail.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56193 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3FWGWP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Jun 2013 02:22:15 -0400
In-Reply-To: <1371967642-3116-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--047d7b15ae1325dc9b04dfcc51eb
Content-Type: text/plain; charset=UTF-8

Hi.

I attached testcases for these ioctls.

Thanks.

2013/6/23 Namjae Jeon <linkinjeon@gmail.com>:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> This patch series introduces 2 new ioctls for ext4.
>
> Truncate_block_range ioctl truncates blocks from source file.
> Transfer_block_range ioctl transfers data blocks from source file
> and append them at the end of destination file.
>
> Ioctl1:         EXT4_IOC_TRUNCATE_BLOCK_RANGE:
> This ioctl truncates a range of data blocks from file.
> It is useful to remove easily and quickly the garbage data
> at the middle of file.
>
> e.g. we have a movie file and there is long advertisement in movie file.
> user want to remove only advertisement range.
>
>  1) Movie file (8GB), There is the adverisement of 500MB size.
>  ____________________________________________________________________
>  |                     |                   |                         |
>  |   a) range          | b) Advertisement  |     c) range            |
>  |                     | (unneeded data)   |                         |
>  |_____________________|___________________|_________________________|
>
>  2) Currently if user want to remove portion b), the conventional way
>     would be to copy a) and c) (7.5GB) to new file by reading data from
>     original file and writing to new file, followed up by  delete original
>     file and rename new file. It will take long time.
>     When we measure time, it takes around 3 minutes.
>
>  3) If we use EXT4_IOC_TRUNCATE_BLOCK_RANGE, we can have garbage data removed
>     in less than a second. Also, no need to perform deletion and rename.
>  _______________________________________________
>  |                     |                        |
>  |   a) range          |     c) range           |
>  |                     |                        |
>  |_____________________|________________________|
>
>
> #define EXT4_IOC_TRUNCATE_BLOCK_RANGE  _IOW('f', 18, struct truncate_range)
> struct truncate_range {
>        __u32 start_block;
>        __u32 length;
> };
>
> example =>
> Originally the file "abc" has the below extent tree:
> debugfs:  ex abc
> Level Entries       Logical        Physical Length Flags
>  0/ 0   1/  3     0 -     4  33615 -  33619      5
>  0/ 0   2/  3     5 -     9  33855 -  33859      5
>  0/ 0   3/  3    10 -    14  69657 -  69661      5
>
> ls -lh abc
> -rw-r--r--    1 root     0          60.0K Jan  1 00:01 abc
>
> du -h abc
> 60.0K   abc
>
> e4_truncate_block_range abc 2 10
> Return:
> : Success
>
> After executing truncate_block_range ioctl, the extent tree:
> ex abc
> Level Entries       Logical        Physical Length Flags
>  0/ 0   1/  2     0 -     1  33615 -  33616      2
>  0/ 0   2/  2     2 -     4  69659 -  69661      3
>
> ls -lh abc
> -rw-r--r--    1 root     0          20.0K Jan  1 00:08 abc
>
> du -h abc
> 20.0K   abc
>
> This ioctl works in 2 parts:
> 1) remove _only_ data blocks that resides within specified range.
> If the entire range is a hole than nothing is removed.
>
> 2) update file's logical block offsets ranging from block number
> "start_block + length" to last logical block of file such that
> lblk_number = lblk_number - length;
> This is done by updating starting block of all the extents that
> resides within the range.
>
> If "start_block + length" is already equal to the last block of file
> than no block is updated. This case is similar to convential truncate.
>
> In the above example:
> The data blocks ranging from [2 - 11] have been removed
> and the logical offsets of the file beyond block number 12 till last block
> of file are updated by subtracting length from each of logical numbers.
> This gives a contiguous logical space to the file.
> Also, the logical size and disksize of the file are updated accordingly.
>
> Ioctl2:         EXT4_IOC_TRANSFER_BLOCK_RANGE:
> This ioctl transfers a range of data blocks from source file and append
> them at the end of the destination file.
> This is not actual data transfer but only metadata is moved.
>
>  ____________________________________________________________________
>  |                     |                   |                         |
>  |   a) range          | b) range          |     c) range            |
>  |                     |                   |                         |
>  |_____________________|___________________|_________________________|
>
> If user does not want b) in the orig file but wants to make a new file
> comprising only b) OR wants b) at the end of an already existing file,
> the conventional way of doing it would be to:
> 1) Copy b) to new file
> 2) Copy c) to temp file
> 3) Truncate orig file to a)
> 4) Copy c) from temp file to the end of orig file.
> 5) Delete temp file.
>
> After this operations =>
> orig_file:
> __________________________________________
> |                     |                   |
> |   a) range          | c) range          |
> |                     |                   |
> |_____________________|___________________|
>
> new_file:
> _______________________
> |                     |
> |   b) range          |
> |                     |
> |_____________________|
>
> Again, this operation would take a long time (depending on the sizes of range)
> if done using conventional way while using transfer_block_range ioctl reduces
> the time within a second.
>
> #define EXT4_IOC_TRANSFER_BLOCK_RANGE  _IOW('f', 19, struct transfer_range)
> struct transfer_range {
>         __u32 dest_fd;
>         __u32 start_block;
>         __u32 length;
> };
>
> example=>
> debugfs: ex source
> Level Entries       Logical        Physical Length Flags
>  0/ 1   1/  1     0 -    24  32809              25
>  1/ 1   1/  5     0 -     4   4071 -   4075      5
>  1/ 1   2/  5     5 -     9   4081 -   4085      5
>  1/ 1   3/  5    10 -    14   4091 -   4095      5
>  1/ 1   4/  5    15 -    19   4101 -   4105      5
>  1/ 1   5/  5    20 -    24   4151 -   4155      5
>
> debugfs:  ex dest
> Level Entries       Logical        Physical Length Flags
>  0/ 0   1/  3     0 -     4  32825 -  32829      5
>  0/ 0   2/  3     5 -     9  33545 -  33549      5
>  0/ 0   3/  3    10 -    14  33615 -  33619      5
>
> ls -lh source
> -rw-r--r--    1 root     0         100.0K Jan  1 00:01 source
> ls -lh dest
> -rw-r--r--    1 root     0          60.0K Jan  1 00:01 dest
>
> du -h source
> 104.0K  source
> du -h dest
> 60.0K   dest
>
> e4_transfer_block_range source dest 2 10
> Return:
> : Success
>
> debugfs:  ex source
> Level Entries       Logical        Physical Length Flags
>  0/ 1   1/  1     0 -    24  32809              25
>  1/ 1   1/  4     0 -     1   4071 -   4072      2
>  1/ 1   2/  4    12 -    14   4093 -   4095      3
>  1/ 1   3/  4    15 -    19   4101 -   4105      5
>  1/ 1   4/  4    20 -    24   4151 -   4155      5
> debugfs:  ex dest
> Level Entries       Logical        Physical Length Flags
>  0/ 1   1/  1     0 -    24  32835              25
>  1/ 1   1/  6     0 -     4  32825 -  32829      5
>  1/ 1   2/  6     5 -     9  33545 -  33549      5
>  1/ 1   3/  6    10 -    14  33615 -  33619      5
>  1/ 1   4/  6    15 -    17   4073 -   4075      3
>  1/ 1   5/  6    18 -    22   4081 -   4085      5
>  1/ 1   6/  6    23 -    24   4091 -   4092      2
>
> ls -lh source
> -rw-r--r--    1 root     0         100.0K Jan  1 00:04 source
> ls -lh dest
> -rw-r--r--    1 root     0         100.0K Jan  1 00:04 dest
>
> du -h source
> 64.0K   source
> du -h dest
> 104.0K  dest
>
> The data blocks lying between [start_block to start_block + length) are appended
> contiguously at the end of destination file.
> The block transfer leaves a hole in the source file.
> If any hole is encountered in the range, it is ommited.
>
> This ioctl does not change the logical size of the source file hence
> leaves a hole in place of transfered range.
> If user want contiguous logical space for source file,
> it can truncate the hole by calling truncate_range_ioctl for source file.
>
> Example for above "source" file:
> e4_truncate_block_range source 2 10
> Return:
> : Success
> debugfs:  ex source
> Level Entries       Logical        Physical Length Flags
>  0/ 1   1/  1     0 -    14  32809              15
>  1/ 1   1/  4     0 -     1   4071 -   4072      2
>  1/ 1   2/  4     2 -     4   4093 -   4095      3
>  1/ 1   3/  4     5 -     9   4101 -   4105      5
>  1/ 1   4/  4    10 -    14   4151 -   4155      5
>
> Namjae Jeon (3):
>   ext4: Add EXT4_IOC_TRUNCATE_BLOCK_RANGE ioctl
>   ext4: make mext_next_extent non static and move get_ext_path
>   ext4: Add EXT4_IOC_TRANSFER_BLOCK_RANGE ioctl
>
> --
> 1.7.9.5
>

--047d7b15ae1325dc9b04dfcc51eb
Content-Type: text/x-csrc; charset=US-ASCII; name="e4_transfer_block_range.c"
Content-Disposition: attachment; filename="e4_transfer_block_range.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hi9uky7a0

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4KI2luY2x1ZGUgPGxpbnV4
L3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCnN0
cnVjdCB0cmFuc2Zlcl9yYW5nZXsKIF9fdTMyIGRlc3RfZmQ7CiBfX3UzMiBzdGFydF9ibG9jazsK
IF9fdTMyIGxlbmd0aDsKfTsKCiNkZWZpbmUgRVhUNF9JT0NfVFJBTlNGRVJfQkxPQ0tfUkFOR0UJ
X0lPVygnZicsIDE5LCBzdHJ1Y3QgdHJhbnNmZXJfcmFuZ2UpCgppbnQgbWFpbihpbnQgYXJnYywg
Y2hhciAqKiBhcmd2KQp7CglpbnQgZGZkLCBmZDsKCXN0cnVjdCB0cmFuc2Zlcl9yYW5nZSB0cjsK
CglpZihhcmdjICE9IDUpewoJCXByaW50ZigiVXNhZ2U6IDxzb3VyY2VmaWxlPiA8ZGVzdGZpbGU+
IDxzdGFydGJsb2NrPiA8bGVuZ3RoPlxuIik7CgkJcmV0dXJuIDA7Cgl9CgoJbWVtc2V0KCZ0ciwg
MCwgc2l6ZW9mKHN0cnVjdCB0cmFuc2Zlcl9yYW5nZSkpOwoJdHIuc3RhcnRfYmxvY2sgPSBhdG9p
KGFyZ3ZbM10pOwoJdHIubGVuZ3RoID0gYXRvaShhcmd2WzRdKTsKCglmZCA9IG9wZW4oYXJndlsx
XSxPX1JEV1IgLDA2NjYpOwoJaWYgKCFmZCkgewoJCXByaW50ZigiQ2Fubm90IG9wZW4gc291cmNl
IGZpbGVcbiIpOwoJCV9leGl0KDEpOwoJfQoKCWRmZCA9IG9wZW4oYXJndlsyXSxPX1JEV1J8T19D
UkVBVCAsMDY2Nik7CglpZiAoIWRmZCkgewoJCXByaW50ZigiQ2Fubm90IG9wZW4gZGVzdCBmaWxl
XG4iKTsKCQlfZXhpdCgxKTsKCX0KCgl0ci5kZXN0X2ZkID0gZGZkOwoJaW9jdGwoZmQsIEVYVDRf
SU9DX1RSQU5TRkVSX0JMT0NLX1JBTkdFLCAmdHIpOwoJY2xvc2UoZmQpOwoJY2xvc2UoZGZkKTsK
CXBlcnJvcigiUmV0dXJuOlxuIik7CglyZXR1cm4gMDsKfQoK
--047d7b15ae1325dc9b04dfcc51eb
Content-Type: text/x-csrc; charset=US-ASCII; name="e4_truncate_block_range.c"
Content-Disposition: attachment; filename="e4_truncate_block_range.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hi9uky7o1

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzeXMvaW9jdGwuaD4KI2luY2x1ZGUgPGxpbnV4
L3R5cGVzLmg+CiNpbmNsdWRlIDxzeXMvc3RhdC5oPgojaW5jbHVkZSA8ZmNudGwuaD4KI2luY2x1
ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDx1bmlzdGQuaD4KCnN0
cnVjdCB0cnVuY2F0ZV9yYW5nZSB7CglfX3UzMiBzdGFydF9ibG9jazsKCV9fdTMyIGxlbmd0aDsK
fTsKCiNkZWZpbmUgRVhUNF9JT0NfVFJVTkNBVEVfQkxPQ0tfUkFOR0UJX0lPVygnZicsIDE4LCBz
dHJ1Y3QgdHJ1bmNhdGVfcmFuZ2UpCgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKiBhcmd2KQp7
CglzdHJ1Y3QgdHJ1bmNhdGVfcmFuZ2UgdHI7CglpbnQgZmQ7CglpZihhcmdjICE9IDQpewoJCXBy
aW50ZigiVXNhZ2U6IDxmaWxlbmFtZT4gPHN0YXJ0YmxvY2s+IDxsZW5ndGg+XG4iKTsKCQlyZXR1
cm4gMDsKCX0KCgltZW1zZXQoJnRyLCAwLCBzaXplb2Yoc3RydWN0IHRydW5jYXRlX3JhbmdlKSk7
Cgl0ci5zdGFydF9ibG9jayA9IGF0b2koYXJndlsyXSk7Cgl0ci5sZW5ndGggPSBhdG9pKGFyZ3Zb
M10pOwoKCWZkID0gb3Blbihhcmd2WzFdLE9fUkRXUiAsMDY2Nik7CglpZihmZCkKCXsKCQlpb2N0
bChmZCwgRVhUNF9JT0NfVFJVTkNBVEVfQkxPQ0tfUkFOR0UsICZ0cik7CgkJY2xvc2UoZmQpOwoJ
fQoJcGVycm9yKCJSZXR1cm46XG4iKTsKCXJldHVybiAwOwp9Cgo=
--047d7b15ae1325dc9b04dfcc51eb--
