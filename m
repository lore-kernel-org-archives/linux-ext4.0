From: Nicolai Stange <nicstange@gmail.com>
Subject: [PATCH v2 2/3] drivers/base/class: __class_register(): make error behaviour consistent
Date: Wed, 18 Nov 2015 17:48:31 +0100
Message-ID: <878u5vckyo.fsf_-_@gmail.com>
References: <871tbpebjw.fsf@gmail.com> <20151117041213.GA10860@kroah.com>
	<87k2pfcl73.fsf_-_@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Nicolai Stange <nicstange@gmail.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87k2pfcl73.fsf_-_@gmail.com> (Nicolai Stange's message of "Wed,
	18 Nov 2015 17:43:28 +0100")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

If a class attribute's sysfs creation fails at the very end of
__class_register(), the kset object already registered for the class itself
is not unregistered again.

This is not consistent with the other possible failures of
__class_register() for which nothing is left over to be manually released
by the caller.

Since class attribute creation does not fail in the real world, the
impact is minimal -- this patch is a cosmetic one.

Make __class_register() follow all-or-nothing semantics, i.e. unregister
the already registered cp->subsys kset object on attribute creation
failure.

Signed-off-by: Nicolai Stange <nicstange@gmail.com>
---
 drivers/base/class.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index c9683cf..fc663d0 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -225,6 +225,12 @@ int __class_register(struct class *cls, struct lock_class_key *key)
 	}
 	error = add_class_attrs(class_get(cls));
 	class_put(cls);
+	if (error) {
+		/* as above, clear cp->class on error */
+		cp->class = NULL;
+		cls->p = NULL;
+		kset_put(&cp->subsys);
+	}
 	return error;
 }
 EXPORT_SYMBOL_GPL(__class_register);
-- 
2.6.3
