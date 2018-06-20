From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/6] ext4: use ktime_get_real_seconds for i_dtime
Date: Wed, 20 Jun 2018 17:33:00 +0200
Message-ID: <20180620153322.54221-3-arnd@arndb.de>
References: <20180620153322.54221-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Tahsin Erdogan <tahsin@google.com>, Jan Kara <jack@suse.cz>,
 Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 Miao Xie <miaoxie@huawei.com>
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Jan Kara <jack@suse.com>
Return-path: <y2038-bounces@lists.linaro.org>
In-Reply-To: <20180620153322.54221-1-arnd@arndb.de>
List-Unsubscribe: <https://lists.linaro.org/mailman/options/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=unsubscribe>
List-Archive: <http://lists.linaro.org/pipermail/y2038/>
List-Post: <mailto:y2038@lists.linaro.org>
List-Help: <mailto:y2038-request@lists.linaro.org?subject=help>
List-Subscribe: <https://lists.linaro.org/mailman/listinfo/y2038>,
 <mailto:y2038-request@lists.linaro.org?subject=subscribe>
Errors-To: y2038-bounces@lists.linaro.org
Sender: "Y2038" <y2038-bounces@lists.linaro.org>
List-Id: linux-ext4.vger.kernel.org

V2Ugb25seSBjYXJlIGFib3V0IHRoZSBsb3cgMzItYml0IGZvciBpX2R0aW1lIGFzIGV4cGxhaW5l
ZCBpbiBjb21taXQKYjVmNTE1NzM1YmVhICgiZXh0NDogYXZvaWQgWTIwMzggb3ZlcmZsb3cgaW4g
cmVjZW50bHlfZGVsZXRlZCgpIiksIHNvCnRoZSB1c2Ugb2YgZ2V0X3NlY29uZHMoKSBpcyBjb3Jy
ZWN0IGhlcmUsIGJ1dCB0aGF0IGZ1bmN0aW9uIGlzIGdldHRpbmcKcmVtb3ZlZCBpbiB0aGUgcHJv
Y2VzcyBvZiB0aGUgeTIwMzggZml4ZXMsIHNvIGxldCdzIHVzZSB0aGUgbW9kZXJuCmt0aW1lX2dl
dF9yZWFsX3NlY29uZHMoKSBoZXJlLgoKU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJu
ZEBhcm5kYi5kZT4KLS0tCiBmcy9leHQ0L2lub2RlLmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9leHQ0L2lub2Rl
LmMgYi9mcy9leHQ0L2lub2RlLmMKaW5kZXggMmVhMDdlZmJlMDE2Li42MDBlMjA2M2QxZGYgMTAw
NjQ0Ci0tLSBhL2ZzL2V4dDQvaW5vZGUuYworKysgYi9mcy9leHQ0L2lub2RlLmMKQEAgLTMxNyw3
ICszMTcsNyBAQCB2b2lkIGV4dDRfZXZpY3RfaW5vZGUoc3RydWN0IGlub2RlICppbm9kZSkKIAkg
KiAoV2VsbCwgd2UgY291bGQgZG8gdGhpcyBpZiB3ZSBuZWVkIHRvLCBidXQgaGVjayAtIGl0IHdv
cmtzKQogCSAqLwogCWV4dDRfb3JwaGFuX2RlbChoYW5kbGUsIGlub2RlKTsKLQlFWFQ0X0koaW5v
ZGUpLT5pX2R0aW1lCT0gZ2V0X3NlY29uZHMoKTsKKwlFWFQ0X0koaW5vZGUpLT5pX2R0aW1lCT0g
a3RpbWVfZ2V0X3JlYWxfc2Vjb25kcygpOwogCiAJLyoKIAkgKiBPbmUgc3VidGxlIG9yZGVyaW5n
IHJlcXVpcmVtZW50OiBpZiBhbnl0aGluZyBoYXMgZ29uZSB3cm9uZwotLSAKMi45LjAKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fClkyMDM4IG1haWxpbmcg
bGlzdApZMjAzOEBsaXN0cy5saW5hcm8ub3JnCmh0dHBzOi8vbGlzdHMubGluYXJvLm9yZy9tYWls
bWFuL2xpc3RpbmZvL3kyMDM4Cg==
