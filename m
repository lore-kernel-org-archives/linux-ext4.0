From: Colin Cross <ccross@android.com>
Subject: Re: linux-next: Tree for Aug 7 [ call-trace on suspend: ext4 | pm
 related ? ]
Date: Wed, 7 Aug 2013 16:34:08 -0700
Message-ID: <CAMbhsRT6eki+oY4D-iRJz2iqS+N3YBmnC0eP4bMN69cbgj=UsQ@mail.gmail.com>
References: <CA+icZUW990rWKdQmppjkGTJzFBtTnW-tb0dRu2AbTYB8KSDN4w@mail.gmail.com>
	<2146168.3J7W6RtiZr@vostro.rjw.lan>
	<CAMbhsRSaJWUL2yBnEJ83TCjMJRSZNP0-XM3-mVYf7FuPtUYnUQ@mail.gmail.com>
	<CA+icZUVCBdFARueFRzAWT6Ax19s83ds5LFvqpQ-tOO96-ZhStA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8ff242a363808d04e363faa7
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux PM List <linux-pm@lists.linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
To: sedat.dilek@gmail.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+icZUVCBdFARueFRzAWT6Ax19s83ds5LFvqpQ-tOO96-ZhStA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--e89a8ff242a363808d04e363faa7
Content-Type: text/plain; charset=ISO-8859-1

On Wed, Aug 7, 2013 at 4:15 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Aug 8, 2013 at 12:58 AM, Colin Cross <ccross@android.com> wrote:
>> Can you try add a call to show_state_filter(TASK_UNINTERRUPTIBLE) in
>> the error path of try_to_freeze_tasks(), where it prints the "refusing
>> to freeze" message?  It will print the stack trace of every thread
>> since they are all in the freezer, so the output will be very long.
>>
>
> If you provide a patch, I will give it a try.

Try the attached patch.

--e89a8ff242a363808d04e363faa7
Content-Type: application/octet-stream;
	name="0001-HACK-print-stack-trace-for-all-tasks-when-freezing-f.patch"
Content-Disposition: attachment;
	filename="0001-HACK-print-stack-trace-for-all-tasks-when-freezing-f.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hk36b8390

RnJvbSBjMTZmMmEyYzM5ZTI5MWU4ZDRmYjM1ZjM0N2M0ZjVmNjNlZWExYzM2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDb2xpbiBDcm9zcyA8Y2Nyb3NzQGFuZHJvaWQuY29tPgpEYXRl
OiBXZWQsIDcgQXVnIDIwMTMgMTY6MzI6MTkgLTA3MDAKU3ViamVjdDogW1BBVENIXSBIQUNLOiBw
cmludCBzdGFjayB0cmFjZSBmb3IgYWxsIHRhc2tzIHdoZW4gZnJlZXppbmcgZmFpbHMKCkNoYW5n
ZS1JZDogSTk4YTU5ZmFhMjU4MDQ1OGVjMGZhODZlNDA0N2YyNzk0MzBjYzgxZjAKLS0tCiBrZXJu
ZWwvcG93ZXIvcHJvY2Vzcy5jIHwgMyArKysKIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KykKCmRpZmYgLS1naXQgYS9rZXJuZWwvcG93ZXIvcHJvY2Vzcy5jIGIva2VybmVsL3Bvd2VyL3By
b2Nlc3MuYwppbmRleCAwNmVjODg2Li41ZDE3NGRmIDEwMDY0NAotLS0gYS9rZXJuZWwvcG93ZXIv
cHJvY2Vzcy5jCisrKyBiL2tlcm5lbC9wb3dlci9wcm9jZXNzLmMKQEAgLTkwLDYgKzkwLDkgQEAg
c3RhdGljIGludCB0cnlfdG9fZnJlZXplX3Rhc2tzKGJvb2wgdXNlcl9vbmx5KQogCQkgICAgICAg
ZWxhcHNlZF9tc2VjcyAvIDEwMDAsIGVsYXBzZWRfbXNlY3MgJSAxMDAwLAogCQkgICAgICAgdG9k
byAtIHdxX2J1c3ksIHdxX2J1c3kpOwogCisJCXByX2Vycigic2hvd2luZyBhbGwgYmxvY2tlZCB0
YXNrc1xuIik7CisJCXNob3dfc3RhdGVfZmlsdGVyKFRBU0tfVU5JTlRFUlJVUFRJQkxFKTsKKwog
CQlpZiAoIXdha2V1cCkgewogCQkJcmVhZF9sb2NrKCZ0YXNrbGlzdF9sb2NrKTsKIAkJCWRvX2Vh
Y2hfdGhyZWFkKGcsIHApIHsKLS0gCjEuOC4zCgo=
--e89a8ff242a363808d04e363faa7--
