From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/8] statx: reject unknown flags when using NULL path
Date: Fri, 31 Mar 2017 18:31:32 +0100
Message-ID: <149098149245.28108.11509992452676050796.stgit@warthog.procyon.org.uk>
References: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, Eric Biggers <ebiggers@google.com>,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
To: viro@zeniv.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The statx() system call currently accepts unknown flags when called with
a NULL path to operate on a file descriptor.  Left unchanged, this could
make it hard to introduce new query flags in the future, since
applications may not be able to tell whether a given flag is supported.

Fix this by failing the system call with EINVAL if any flags other than
KSTAT_QUERY_FLAGS are specified in combination with a NULL path.

Arguably, we could still permit known lookup-related flags such as
AT_SYMLINK_NOFOLLOW.  However, that would be inconsistent with how
sys_utimensat() behaves when passed a NULL path, which seems to be the
closest precedent.  And given that the NULL path case is (I believe)
mainly intended to be used to implement a wrapper function like fstatx()
that doesn't have a path argument, I think rejecting lookup-related
flags too is probably the best choice.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/stat.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/stat.c b/fs/stat.c
index fa0be59340cc..df484a60846d 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -130,9 +130,13 @@ EXPORT_SYMBOL(vfs_getattr);
 int vfs_statx_fd(unsigned int fd, struct kstat *stat,
 		 u32 request_mask, unsigned int query_flags)
 {
-	struct fd f = fdget_raw(fd);
+	struct fd f;
 	int error = -EBADF;
 
+	if (query_flags & ~KSTAT_QUERY_FLAGS)
+		return -EINVAL;
+
+	f = fdget_raw(fd);
 	if (f.file) {
 		error = vfs_getattr(&f.file->f_path, stat,
 				    request_mask, query_flags);
