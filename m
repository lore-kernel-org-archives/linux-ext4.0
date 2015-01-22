From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH] ext4: fix warning in ext4_da_update_reserve_space()
Date: Wed, 21 Jan 2015 21:31:13 -0600
Message-ID: <54C06F01.7090604@akamai.com>
References: <1420750108-11512-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"tytso@mit.edu" <tytso@mit.edu>, "jack@suse.cz" <jack@suse.cz>
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1420750108-11512-1-git-send-email-johunt@akamai.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 01/08/2015 02:48 PM, Josh Hunt wrote:
>      Please add the patch below and referenced dependency (0e95c22) to stable
>      3.10.y. The original 7d73453 did not apply cleanly to my 3.10.y so I've
>      backported it here. Its dependency can be cherry-picked.
>
>      I've gotten approval to submit these to 3.10 stable from Jan and Ted, also
>      cc'd.
>      http://marc.info/?l=linux-ext4&m=142070334408249&w=2
>
>      Thanks
>      Josh
>
>      -----
>
>      commit 7d7345322d60edb0fa49a64a89b31360f01d09cb upstream
>
>      reaim workfile.dbase test easily triggers warning in
>      ext4_da_update_reserve_space():
>
>      EXT4-fs warning (device ram0): ext4_da_update_reserve_space:365:
>      ino 12, allocated 1 with only 0 reserved metadata blocks (releasing 1
>      blocks with reserved 9 data blocks)
>
>      The problem is that (one of) tests creates file and then randomly writes
>      to it with O_SYNC. That results in writing back pages of the file in
>      random order so we create extents for written blocks say 0, 2, 4, 6, 8
>      - this last allocation also allocates new block for extents. Then we
>      writeout block 1 so we have extents 0-2, 4, 6, 8 and we release
>      indirect extent block because extents fit in the inode again. Then we
>      writeout block 10 and we need to allocate indirect extent block again
>      which triggers the warning because we don't have the reservation
>      anymore.
>
>      Fix the problem by giving back freed metadata blocks resulting from
>      extent merging into inode's reservation pool.
>
>      Cc: <stable@vger.kernel.org> # 3.10.x: 0e95c22: quota: provide interface for readding allocated space into reserved space
>      Cc: <stable@vger.kernel.org> # 3.10.x
>      Signed-off-by: Jan Kara <jack@suse.cz>

I've just realized the patch dependency I referenced above, 0e95c22, is 
incorrect. It should have been 1c8924eb106. Sorry for any confusion.

Let me know if I you'd like me to respin the patch with the proper hash 
information.

Thanks
Josh
