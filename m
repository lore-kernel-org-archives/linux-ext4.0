From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v4 1/5] mm: add mkwrite param to vm_insert_mixed()
Date: Mon, 24 Jul 2017 13:25:30 +0200
Message-ID: <20170724112530.GI652@quack2.suse.cz>
References: <20170721223956.29485-1-ross.zwisler@linux.intel.com>
 <20170721223956.29485-2-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Cc: Jan Kara <jack@suse.cz>, linux-doc@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>,
 Christoph Hellwig <hch@lst.de>, linux-samsung-soc@vger.kernel.org,
 "Darrick J. Wong" <darrick.wong@oracle.com>,
 Tomi Valkeinen <tomi.valkeinen@ti.com>,
 Kyungmin Park <kyungmin.park@samsung.com>,
 Krzysztof Kozlowski <krzk@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 linux-ext4@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>,
 linux-arm-msm@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
 linux-nvdimm@lists.01.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Dan Williams <dan.j.williams@intel.com>, linux-arm-kernel@lists.infradead.org,
 Theodore Ts'o <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>,
 Seung-Woo Kim <sw0312.kim@samsung.com>, linux-kernel@vger.kernel.org,
 linux-xfs@v
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <dri-devel-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20170721223956.29485-2-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
List-Id: linux-ext4.vger.kernel.org

PiBAQCAtMTY1OCwxNCArMTY1OCwyOCBAQCBzdGF0aWMgaW50IGluc2VydF9wZm4oc3RydWN0IHZt
X2FyZWFfc3RydWN0ICp2bWEsIHVuc2lnbmVkIGxvbmcgYWRkciwKPiAgCWlmICghcHRlKQo+ICAJ
CWdvdG8gb3V0Owo+ICAJcmV0dmFsID0gLUVCVVNZOwo+IC0JaWYgKCFwdGVfbm9uZSgqcHRlKSkK
PiAtCQlnb3RvIG91dF91bmxvY2s7Cj4gKwlpZiAoIXB0ZV9ub25lKCpwdGUpKSB7Cj4gKwkJaWYg
KG1rd3JpdGUpIHsKPiArCQkJaWYgKFdBUk5fT05fT05DRShwdGVfcGZuKCpwdGUpICE9IHBmbl90
X3RvX3BmbihwZm4pKSkKCklzIHRoZSBXQVJOX09OX09OQ0UoKSByZWFsbHkgYXBwcm9wcmlhdGUg
aGVyZT8gWW91ciB0ZXN0Y2FzZSB3aXRoIHByaXZhdGUKbWFwcGluZ3MgaGFzIHRyaWdnZXJlZCB0
aGlzIHNpdHVhdGlvbiBpZiBJJ20gcmlnaHQuLi4KCk90aGVyd2lzZSB0aGUgcGF0Y2ggbG9va3Mg
Z29vZCB0byBtZS4KCgkJCQkJCQkJSG9uemEKCi0tIApKYW4gS2FyYSA8amFja0BzdXNlLmNvbT4K
U1VTRSBMYWJzLCBDUgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwpkcmktZGV2ZWwgbWFpbGluZyBsaXN0CmRyaS1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5v
cmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9kcmktZGV2
ZWwK
