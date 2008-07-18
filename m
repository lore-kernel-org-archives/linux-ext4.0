From: m-ota@ys.jp.nec.com
Subject: what should I do when an error occurred after write_begin()
Date: Fri, 18 Jul 2008 09:43:15 +0900
Message-ID: <20080718094315m-ota@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

 Hi, all
 
 ext4 online defrag exchanges the data block in the following procedures.
 
 1. Creates a temporary inode and allocates contiguous blocks.
 2. Read data from original file to memory page by write_begin()
 3. Swap the blocks between the original inode and the temporary inode.
    Updates the extent tree and registers the block to transaction by
    ext4_journal_dirty_metadata().
 4. Write data in memory page to new blocks by write_end().
 
 In the current implementation, when the block swap failed,
 data could not move to the new block.
 So the defrag process exits without calling write_end().
 We try to defrag for the same file again, but the defrag process seems to stall.
 After defrag process stalled, all acess to the file systems like "ls" command
 also stall.
 Both processes wait for unlock j_wait_transaction_locked.
 
 If the block exchange between write_begin() and write_end() failed,
 what should I do?
 
 Any advice is welcome, thank you.
     Mikako ohta
