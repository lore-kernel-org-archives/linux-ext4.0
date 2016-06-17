From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] jbd2: make journal y2038 safe
Date: Fri, 17 Jun 2016 17:39:00 +0200
Message-ID: <20160617153916.444842-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: y2038@lists.linaro.org, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Jan Kara <jack@suse.com>
Return-path: <y2038-bounces@lists.linaro.org>
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

VGhlIGpiZDIgam91cm5hbCBzdG9yZXMgdGhlIGNvbW1pdCB0aW1lIGluIDY0LWJpdCBzZWNvbmRz
IGFuZCAzMi1iaXQKbmFub3NlY29uZHMsIHdoaWNoIGF2b2lkcyBhbiBvdmVyZmxvdyBpbiAyMDM4
LCBidXQgaXQgZ2V0cyB0aGUgbnVtYmVycwpmcm9tIGN1cnJlbnRfa2VybmVsX3RpbWUoKSwgd2hp
Y2ggdXNlcyAnbG9uZycgc2Vjb25kcyBvbiAzMi1iaXQKYXJjaGl0ZWN0dXJlcy4KClRoaXMgc2lt
cGx5IGNoYW5nZXMgdGhlIGNvZGUgdG8gY2FsbCBjdXJyZW50X2tlcm5lbF90aW1lNjQoKSBzbwp3
ZSB1c2UgNjQtYml0IHNlY29uZHMgY29uc2lzdGVudGx5LgoKU2lnbmVkLW9mZi1ieTogQXJuZCBC
ZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KLS0tCiBmcy9qYmQyL2NvbW1pdC5jIHwgMiArLQogMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
ZnMvamJkMi9jb21taXQuYyBiL2ZzL2piZDIvY29tbWl0LmMKaW5kZXggOGY3ZDEzMzljOTczLi41
YmI1NjVmOTk4OWMgMTAwNjQ0Ci0tLSBhL2ZzL2piZDIvY29tbWl0LmMKKysrIGIvZnMvamJkMi9j
b21taXQuYwpAQCAtMTI0LDcgKzEyNCw3IEBAIHN0YXRpYyBpbnQgam91cm5hbF9zdWJtaXRfY29t
bWl0X3JlY29yZChqb3VybmFsX3QgKmpvdXJuYWwsCiAJc3RydWN0IGNvbW1pdF9oZWFkZXIgKnRt
cDsKIAlzdHJ1Y3QgYnVmZmVyX2hlYWQgKmJoOwogCWludCByZXQ7Ci0Jc3RydWN0IHRpbWVzcGVj
IG5vdyA9IGN1cnJlbnRfa2VybmVsX3RpbWUoKTsKKwlzdHJ1Y3QgdGltZXNwZWM2NCBub3cgPSBj
dXJyZW50X2tlcm5lbF90aW1lNjQoKTsKIAogCSpjYmggPSBOVUxMOwogCi0tIAoyLjkuMAoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KWTIwMzggbWFpbGlu
ZyBsaXN0ClkyMDM4QGxpc3RzLmxpbmFyby5vcmcKaHR0cHM6Ly9saXN0cy5saW5hcm8ub3JnL21h
aWxtYW4vbGlzdGluZm8veTIwMzgK
