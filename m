From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.6
Date: Sun, 10 Apr 2016 13:50:11 -0700
Message-ID: <CA+55aFyGeZTy291E5jRkF63qBL=cRpLVw4FGzePZR7FhNUFp_w@mail.gmail.com>
References: <xr93bn5iyzeq.fsf@gthelen.mtv.corp.google.com>
	<CA+55aFwdgD1Y7caKoL=8aPvoKUwObA-Fa8LypPBZMA87pBcu1w@mail.gmail.com>
	<CA+55aFzfmHptveL=y1C5VidQjjiSekcCq=-fg1Z-W6Szog-VRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001a1137665a04d4b905302793ff
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Greg Thelen <gthelen@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzfmHptveL=y1C5VidQjjiSekcCq=-fg1Z-W6Szog-VRA@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--001a1137665a04d4b905302793ff
Content-Type: text/plain; charset=UTF-8

On Sun, Apr 10, 2016 at 1:48 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> The attached patch is actually tested and seems to fix the issue.

Christ. Now really attached.

I'll just go back to bed, because today is just not working out. Maybe
things will be better tomorrow.

Or maybe I should start drinking, and at least have an excuse.

              Linus

--001a1137665a04d4b905302793ff
Content-Type: text/plain; charset=US-ASCII; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_imv1mscb0

IGZzL2V4dDQvbmFtZWkuYyB8IDIgKy0KIGZzL3JlYWRkaXIuYyAgICB8IDIgKysKIDIgZmlsZXMg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZnMv
ZXh0NC9uYW1laS5jIGIvZnMvZXh0NC9uYW1laS5jCmluZGV4IGRiOThmODlmNzM3Zi4uYzA3NDIy
ZDI1NGI2IDEwMDY0NAotLS0gYS9mcy9leHQ0L25hbWVpLmMKKysrIGIvZnMvZXh0NC9uYW1laS5j
CkBAIC0xMTA3LDcgKzExMDcsNyBAQCBpbnQgZXh0NF9odHJlZV9maWxsX3RyZWUoc3RydWN0IGZp
bGUgKmRpcl9maWxlLCBfX3UzMiBzdGFydF9oYXNoLAogCX0KIAogCXdoaWxlICgxKSB7Ci0JCWlm
IChzaWduYWxfcGVuZGluZyhjdXJyZW50KSkgeworCQlpZiAoZmF0YWxfc2lnbmFsX3BlbmRpbmco
Y3VycmVudCkpIHsKIAkJCWVyciA9IC1FUkVTVEFSVFNZUzsKIAkJCWdvdG8gZXJyb3V0OwogCQl9
CmRpZmYgLS1naXQgYS9mcy9yZWFkZGlyLmMgYi9mcy9yZWFkZGlyLmMKaW5kZXggZTY5ZWYzYjc5
Nzg3Li4yYjBiYjRmYjg5OTAgMTAwNjQ0Ci0tLSBhL2ZzL3JlYWRkaXIuYworKysgYi9mcy9yZWFk
ZGlyLmMKQEAgLTI0OCw2ICsyNDgsOCBAQCBzdGF0aWMgaW50IGZpbGxkaXI2NChzdHJ1Y3QgZGly
X2NvbnRleHQgKmN0eCwgY29uc3QgY2hhciAqbmFtZSwgaW50IG5hbWxlbiwKIAkJcmV0dXJuIC1F
SU5WQUw7CiAJZGlyZW50ID0gYnVmLT5wcmV2aW91czsKIAlpZiAoZGlyZW50KSB7CisJCWlmIChz
aWduYWxfcGVuZGluZyhjdXJyZW50KSkKKwkJCXJldHVybiAtRUlOVFI7CiAJCWlmIChfX3B1dF91
c2VyKG9mZnNldCwgJmRpcmVudC0+ZF9vZmYpKQogCQkJZ290byBlZmF1bHQ7CiAJfQo=
--001a1137665a04d4b905302793ff--
