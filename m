From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: ext4: calculate and verify checksums of directory leaf blocks
Date: Mon, 30 Apr 2012 14:05:35 +0300
Message-ID: <20120430110535.GA22505@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:22464 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab2D3LFm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Apr 2012 07:05:42 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello Darrick J. Wong,

This is a semi-automatic email about new static checker warnings.

The patch b0336e8d2108: "ext4: calculate and verify checksums of 
directory leaf blocks" from Apr 29, 2012, leads to the following 
Smatch complaint:

fs/ext4/namei.c:1615 add_dirent_to_buf()
	 warn: variable dereferenced before check 'inode' (see line 1577)

fs/ext4/namei.c
  1575          if (EXT4_HAS_RO_COMPAT_FEATURE(inode->i_sb,
                                               ^^^^^^^^^^^
New dereference.

  1576					       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
  1577			csum_size = sizeof(struct ext4_dir_entry_tail);
  1578	
  1579		reclen = EXT4_DIR_REC_LEN(namelen);
  1580		if (!de) {
  1581			de = (struct ext4_dir_entry_2 *)bh->b_data;
  1582			top = bh->b_data + (blocksize - csum_size) - reclen;
  1583			while ((char *) de <= top) {
  1584				if (ext4_check_dir_entry(dir, NULL, de, bh, offset))
  1585					return -EIO;
  1586				if (ext4_match(namelen, name, de))
  1587					return -EEXIST;
  1588				nlen = EXT4_DIR_REC_LEN(de->name_len);
  1589				rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
  1590				if ((de->inode? rlen - nlen: rlen) >= reclen)
  1591					break;
  1592				de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
  1593				offset += rlen;
  1594			}
  1595			if ((char *) de > top)
  1596				return -ENOSPC;
  1597		}
  1598		BUFFER_TRACE(bh, "get_write_access");
  1599		err = ext4_journal_get_write_access(handle, bh);
  1600		if (err) {
  1601			ext4_std_error(dir->i_sb, err);
  1602			return err;
  1603		}
  1604	
  1605		/* By now the buffer is marked for journaling */
  1606		nlen = EXT4_DIR_REC_LEN(de->name_len);
  1607		rlen = ext4_rec_len_from_disk(de->rec_len, blocksize);
  1608		if (de->inode) {
  1609			struct ext4_dir_entry_2 *de1 = (struct ext4_dir_entry_2 *)((char *)de + nlen);
  1610			de1->rec_len = ext4_rec_len_to_disk(rlen - nlen, blocksize);
  1611			de->rec_len = ext4_rec_len_to_disk(nlen, blocksize);
  1612			de = de1;
  1613		}
  1614		de->file_type = EXT4_FT_UNKNOWN;
  1615		if (inode) {
                    ^^^^^
Old check.

  1616			de->inode = cpu_to_le32(inode->i_ino);
  1617			ext4_set_de_type(dir->i_sb, de, inode->i_mode);

regards,
dan carpenter

