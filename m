From: Anton Altaparmakov <aia21@cam.ac.uk>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 13 Sep 2008 22:17:07 +0100
Message-ID: <2EC8176B-0AFA-4B36-A2F5-E51753A576A5@cam.ac.uk>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1221331767-16870-1-git-send-email-tytso@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

Just a quick question (not a criticism of the patches in any way):

Is there a specific reason that the flag FIEMAP_EXTENT_DATA_ENCRYPTED  
exists?  I am only asking because there isn't a  
FIEMAP_EXTENT_DATA_COMPRESSED flag yet the effect on the data is the  
same.  I suppose one could argue that compression is a form of  
encryption (as one cannot read the data on disk without decompressing  
it) and thus for compressed files I can just set  
FIEMAP_EXTENT_DATA_ENCRYPTED, too?

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

