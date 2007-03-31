From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] Correction to check_filetype()
Date: Fri, 30 Mar 2007 20:44:17 -0400
Message-ID: <20070331004417.GJ3198@thunk.org>
References: <1172049359.4727.15.camel@garfield>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Cc: Andreas Dilger <adilger@clusterfs.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Lustre-discuss <Lustre-discuss@clusterfs.com>
To: Kalpak Shah <kalpak@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:35358 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204AbXCaAoV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 30 Mar 2007 20:44:21 -0400
Content-Disposition: inline
In-Reply-To: <1172049359.4727.15.camel@garfield>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 21, 2007 at 02:45:59PM +0530, Kalpak Shah wrote:
> 
> If the mode of a directory gets corrupted, check_filetype() makes
> wrong decisions for all its sub-directories. For example, using
> debugfs we can corrupt the mode of a directory to 0140755 (i.e. a
> socket). e2fsck will set the filetype of all its subdirectories as 6
> (filetype for socket). All the subdirectories would be moved to
> lost+found, and in second run of e2fsck their filetype would be set
> back to 2.

Um, I'm not seeing this.  Using stock e2fsprogs, given the following
test image, I'm not seeing the behavior you describe.  

It does require a second e2fsck to fix things, which is bad; we need
to make sure the i_size is fixed in pass 1.

						- Ted

e2fsck 1.40-WIP (14-Nov-2006)
Pass 1: Checking inodes, blocks, and sizes
Inode 12, i_blocks is 2, should be 0.  Fix? yes

Pass 2: Checking directory structure
Entry 'dir' in / (2) has an incorrect filetype (was 2, should be 6).
Fix? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 2 ref count is 4, should be 3.  Fix? yes

Inode 12 ref count is 2, should be 1.  Fix? yes

Unattached inode 13
Connect to /lost+found? yes

Inode 13 ref count is 2, should be 1.  Fix? yes

Unattached inode 14
Connect to /lost+found? yes

Inode 14 ref count is 2, should be 1.  Fix? yes

Unattached inode 15
Connect to /lost+found? yes

Inode 15 ref count is 2, should be 1.  Fix? yes

Pass 5: Checking group summary information
Block bitmap differences:  -21
Fix? yes

Free blocks count wrong for group #0 (75, counted=76).
Fix? yes

Free blocks count wrong (75, counted=76).
Fix? yes

Directories count wrong for group #0 (3, counted=2).
Fix? yes


foo.img: ***** FILE SYSTEM WAS MODIFIED *****
foo.img: 15/16 files (0.0% non-contiguous), 24/100 blocks
<tytso@candygram> {/usr/projects/e2fsprogs/e2fsprogs/build/e2fsck}  
730% e2fsck -fy foo.img
e2fsck 1.40-WIP (14-Nov-2006)
Pass 1: Checking inodes, blocks, and sizes
Special (device/socket/fifo) inode 12 has non-zero size.  Fix? yes

Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

foo.img: ***** FILE SYSTEM WAS MODIFIED *****
foo.img: 15/16 files (0.0% non-contiguous), 24/100 blocks

--J/dobhs11T7y2rNN
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="foo.img.gz"
Content-Transfer-Encoding: base64

H4sICLiiDUYCA2Zvby5pbWcA7du9axNhHAfwu0t8axtfaq0dBAVxEoovg1OHLkWtiqAIblpi
oVA8bFNws52d/A9a6OCog2upg4OTDg7ujlJcOggi8cldElJbX0M1ms8HvuSSXPhxT57fcffA
RRHQrfaHlEN2hIyHxPU0HctT2+/qUmmsEhJHg9G1D3G239vF0lh0ZS3btfG73pD5kFMhSf3z
o1MPj5x4dunT4/fvHh3/fOvc3zjWJ+no4o3Vy/3LlfL06Rfrr5KW77Lj2AaxKUYHK4QUm/0f
Z++B7lCtVpvbH6tAV3lgCKBbtd7/NvInrz/WRldGajcg15dKYzfrqX2+MlKMWu/Pd7lUYxvM
L9QWqorFzfM/3jD/fseA4e14q6P5QuXm/z+Jhlr22x2yJ6Snvr7ZF1IK2Ruyr76OeiCkP+Tg
r5z/nucLMBPhvJfW06jfOv8OtXGM55+uv/zWd8sL+drPVKjbyFbzf7CN+hd+UH9neJ0OdRvZ
qv7hNupf/In66abx31h/qI3649+p/7cl2VyOk+HmdpIMD+dzfCDqSabT2crJyXTubjmf828K
haQ8NePEAf+B3q/6f72Q9z/QJYqGAPQ/oP8B/Q/of0D/A/of0P+A/gf0P6D/AYBO1hdt/fxf
KdsuxJNpmj3jWtueuD2TPev6ulCM783N3Td68G+r3Jmt9BgG6Nr+P+MEAF3b/2f1PwAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAQMf7AglWTOsAkAEA

--J/dobhs11T7y2rNN--
