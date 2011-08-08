From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: [PATCH 0/4] Series short description
Date: Mon, 08 Aug 2011 17:37:52 +0200
Message-ID: <20110808153432.1872437.85783.stgit@fsdevel3>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: hch@infradead.org, yong.fan@whamcloud.com,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, adilger@whamcloud.com
To: linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

With the ext3/ext4 directory index implementation hashes are used to specify
offsets for llseek(). For compatibility with NFSv2 and 32-bit user space
on 64-bit systems (kernel space) ext3/ext4 currently only return 32-bit 
hashes and therefore the probability of hash collisions for larger directories
is rather high. As recently reported on the NFS mailing list that theoretical
problem also happens on real systems:
http://comments.gmane.org/gmane.linux.nfs/40863

The following series adds two new f_mode flags to tell ext4
to use 32-bit or 64-bit hash values for llseek() calls.
These flags can then used by network file systems, such as NFS, to
request 32-bit or 64-bit offsets (hashes).

Version 2:
- use f_mode instead of O_* flags and also in a separate patch
- introduce EXT4_HTREE_EOF_32BIT and EXT4_HTREE_EOF_64BIT
- fix SEEK_END in ext4_dir_llseek()
- set f_mode flags in NFS code as early as possible and introduce a new
  NFSD_MAY_64BIT_COOKIE flag for that

--
Bernd Schubert
Fraunhofer ITWM
