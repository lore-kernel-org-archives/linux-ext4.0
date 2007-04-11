From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Subject: ext3, BKL, journal replay, multiple non-bind mounts of same device
Date: Tue, 10 Apr 2007 20:49:16 -0400 (EDT)
Message-ID: <alpine.DEB.0.83.0704102041210.7971@sigma.j-a-k-j.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
To: kernelnewbies@nl.linux.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Since it is possible for the same block device to be mounted multiple 
times concurrently by the same filesystem, and since ext3 explicitly 
disables the BKL during its fill_super operation which would prevent this, 
what is the result of mounting it multiple times this way? Especially if 
the filesystem is dirty and a journal is replayed. (In any case, what 
operation is being performed by ext3/ext4 that requires the BKL to be 
dropped? What's the need to even consider the BKL during fill_super?)

And in general, how does a filesystem deal with being mounted multiple 
times in this way? In my testing and exploration so far, everything seems 
to generally work, but I haven't tried deliberately using different 
instances of the mount concurrently. Do we end up with locks not being 
held properly on the superblock because the super_block structure 
instances don't know about each other? Has dealing with this behavior of 
bd_claim really been considered before, and if so, what's the general 
scheme for handling it?
