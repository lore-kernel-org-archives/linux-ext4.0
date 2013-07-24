From: Dhaval Giani <dgiani@mozilla.com>
Subject: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Wed, 24 Jul 2013 17:03:53 -0400
Message-ID: <1374699833.7083.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tytso@mit.edu, tglek@mozilla.com, vdjeric@mozilla.com,
	glandium@mozilla.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Hi there!

I am posting this series early in its development phase to solicit some
feedback.

We are implementing transparent decompression with a focus on ext4. One
of the main usecases is that of Firefox on Android. Currently libxul.so
is compressed and it is loaded into memory by a custom linker on
demand. With the use of transparent decompression, we can make do
without the custom linker. More details (i.e. code) about the linker can
be found at https://github.com/glandium/faulty.lib

Patch 1 introduces the seekable zip format to the kernel. The tool to
create the szip file can be found in the git repository mentioned
earlier. Patch 2 introduces transparent decompression to ext4. This
patch is really ugly, but it gives an idea of what I am upto right now.

Now let's move on the interesting bits.

There are a few flaws with the current approach (though most are easily
fixable)
1. The decompression takes place very late. We probably want to be
decompressing soon after get the data off disk.
2. No seek support. This is for simplicity as I was experimenting with
filesystems for the first time. I have a patch that does it, but it is
too ugly to see the world. I will fix it up in time for the next set.
3. No mmap support. For a similar reason as 1. There is no reason it
cannot be done, it just has not been done correctly.
4. stat still returns the compressed size. We need to modify
compressed files to return uncompressed size.
5. Implementation is tied to the szip format. However it is quite easy
to decouple the compression scheme from the filesystem. I will probably
get to that in another 2 rounds (first goal is to get seek support
working fine, and mmap in place)
6. Introduction of an additional file_operation to decompress the
buffer. This will be *removed* in the next posting once I have seek
support implemented properly.
7. The compressed file is read only. In order to write to the file, it
shall have to be replaced.
8. The kernel learns that the file is compressed with the use of the
chattr tool. For now I am abusing the +c flag. Please let me know if
that should not be used.

In order to try this patch out, please create an szip file using the
szip tool. Then, read the file. Just ensure that the buffer you provide
to the kernel is big enough to fit the uncompressed file (and that you
read the whole file in one go.)

Thanks!
Dhaval

--
Dhaval Giani (2):
  szip: Add seekable zip format
  Add rudimentary transparent decompression support to ext4

 fs/ext4/file.c       |  66 ++++++++++++++++
 fs/read_write.c      |   3 +
 include/linux/fs.h   |   1 +
 include/linux/szip.h |  32 ++++++++
 lib/Kconfig          |   8 ++
 lib/Makefile         |   1 +
 lib/szip.c           | 217 +++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 328 insertions(+)
 create mode 100644 include/linux/szip.h
 create mode 100644 lib/szip.c

-- 
1.8.1.4
