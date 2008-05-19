From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Scripting e2fsck: no errors, but still exit code 1 "FILE	SYSTEM
 WAS MODIFIED"
Date: Mon, 19 May 2008 13:23:24 +0200
Message-ID: <4831632C.4010509@tuxes.nl>
References: <483006F1.6080008@tuxes.nl> <20080518122853.GB31413@mit.edu> <483056DC.4060108@tuxes.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from a-eskwadraat.nl ([131.211.39.72]:56207 "EHLO a-eskwadraat.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbYESLuW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 May 2008 07:50:22 -0400
In-Reply-To: <483056DC.4060108@tuxes.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bas van Schaik wrote:
> Theodore Tso wrote:
>   
>> On Sun, May 18, 2008 at 12:37:37PM +0200, Bas van Schaik wrote:
>>   
>>     
>>> However, there is a slight
>>> problem with scripting e2fsck: it seems that e2fsck /always/ exits with
>>> exit code 1 just because of the fact that the snapshot journal has been
>>> replayed. Because of this, the script cannot tell whether there is a
>>> real problem or not and keeps e-mailing me. This is a typical output of
>>> such an e2fsck run:
>>>     
>>>       
>> Simply replying the journal should not cause e2fsck to have an exit
>> code of 1.  It must have done something else.  The common one was
>> clearing the LARGE_FILES feature flag if the filesystem didn't have
>> one, but that was removed as of 1.40.7.  Can you take a snapshot, run
>> dumpe2fs, run e2fsck -fy /dev/loop1, and then run dumpe2fs again, and
>> send me a before and after?
>>     
> For now, the dumpe2fs before the e2fsck. As you will probably remember,
> the filesystem is quite large and and the check takes a few hours... I
> will send the other dumpe2fs ASAP.
>
>
>   
>> # dumpe2fs /dev/loop1
>> dumpe2fs 1.40-WIP (14-Nov-2006)
>> Filesystem volume name:   <none>
>> Last mounted on:          <not available>
>> Filesystem UUID:          5e561184-65a5-4e19-9b57-7acf31ef209b
>> Filesystem magic number:  0xEF53
>> Filesystem revision #:    1 (dynamic)
>> Filesystem features:      has_journal dir_index filetype
>> needs_recovery sparse_super large_file
>> Filesystem flags:         signed directory hash
>> Default mount options:    journal_data_writeback
>> Filesystem state:         clean
>> Errors behavior:          Remount read-only
>> Filesystem OS type:       Linux
>> Inode count:              275251200
>> Block count:              550502400
>> Reserved block count:     0
>> Free blocks:              64737800
>> Free inodes:              262708704
>> First block:              0
>> Block size:               4096
>> Fragment size:            4096
>> Blocks per group:         32768
>> Fragments per group:      32768
>> Inodes per group:         16384
>> Inode blocks per group:   512
>> Filesystem created:       Fri Oct  6 20:46:50 2006
>> Last mount time:          Tue May 13 00:30:58 2008
>> Last write time:          Tue May 13 00:30:58 2008
>> Mount count:              1
>> Maximum mount count:      24
>> Last checked:             Mon May 12 15:38:20 2008
>> Check interval:           15552000 (6 months)
>> Next check after:         Sat Nov  8 14:38:20 2008
>> Reserved blocks uid:      0 (user root)
>> Reserved blocks gid:      0 (group root)
>> First inode:              11
>> Inode size:               128
>> Journal inode:            8
>> Default directory hash:   tea
>> Directory Hash Seed:      46c1768d-baa8-44f8-a823-200942db69b5
>> Journal backup:           inode blocks
>> Journal size:             32M
>>     

And now the output of dumpe2fs after the e2fsck:
> Filesystem state:         clean
> Errors behavior:          Remount read-only
> Filesystem OS type:       Linux
> Inode count:              275251200
> Block count:              550502400
> Reserved block count:     0
> Free blocks:              76760569
> Free inodes:              262667659
> First block:              0
> Block size:               4096
> Fragment size:            4096
> Blocks per group:         32768
> Fragments per group:      32768
> Inodes per group:         16384
> Inode blocks per group:   512
> Filesystem created:       Fri Oct  6 20:46:50 2006
> Last mount time:          Mon May 19 02:15:24 2008
> Last write time:          Mon May 19 02:16:08 2008
> Mount count:              0
> Maximum mount count:      24
> Last checked:             Mon May 19 02:16:08 2008
> Check interval:           15552000 (6 months)
> Next check after:         Sat Nov 15 01:16:08 2008
> Reserved blocks uid:      0 (user root)
> Reserved blocks gid:      0 (group root)
> First inode:              11
> Inode size:               128
> Journal inode:            8
> Default directory hash:   tea
> Directory Hash Seed:      46c1768d-baa8-44f8-a823-200942db69b5
> Journal backup:           inode blocks
> Journal size:             32M

Does this tell you anything?

  -- Bas

